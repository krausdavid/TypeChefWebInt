/*
 * Copyright (c) 2010 Thorsten Berger <berger@informatik.uni-leipzig.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package gsd.buildanalysis.linux.model

import kiama.attribution.Attribution._
import kiama.attribution.Attributable
import kiama.rewriting.Rewriter
import gsd.common.Logging
import gsd.buildanalysis.linux.{PersistenceManager, Expression}

/**
 * Represents the AST we derive from the whole build system.
 */
case class BNode( ntype: BNodeType,
                  subnodes: List[BNode],  // "children" collides with a field in Attributable
                  exp: Option[Expression],
                  details: BNodeDetails ) extends Attributable{

  override def toString = this match{
    case BNode( RootNode, _, _, _ ) => "[root]"
    case BNode( _, _, _, MakefileDetails(m) ) => "[Makefile: " + m + "]"
    case BNode( _, _, _, ObjectDetails(oF,_,_,_,_,_,_) ) => "[Object: " + oF + "]"
    case BNode( _, _, _, VariableDefinitionDetails(v) ) => "[VariableDefinition: " + v + "]"
    case BNode( _, _, _, VariableReferenceDetails(v) ) => "[VariableReference: " + v + "]"
    case _ => super.toString
  }

}

sealed abstract class BNodeType

case object RootNode extends BNodeType
case object IfBNode extends BNodeType
case object MakefileBNode extends BNodeType
case object ObjectBNode extends BNodeType
case object TempCompositeListBNode extends BNodeType
case object TempReferenceBNode extends BNodeType

/**
 * other variables that define lists of objects, e.g. like:
 COMMON_FILES:= \
 \
	data_skip.o \
	data_extract_all.o \
	data_extract_to_stdout.o
 */
case object VariableDefinitionBNode extends BNodeType

/**
 * arbitrary variables that get referenced
 * represents a reference to a variable in one of the list assignments, e.g. like:
 * obj-y += ${COMMON_FILES} test.o
 */
case object VariableReferenceBNode extends BNodeType

/**
 * Similar to VariableDefinitionBNode, but catches all other variable definitions
 * and assignments (i.e. where the values aren't lists of objects)
 */
case object VariableAssignmentBNode extends BNodeType


/**
 * Detailed information per BNode
 */
sealed abstract class BNodeDetails

case object NoDetails extends BNodeDetails

case class ObjectDetails( objectFile: String,
                          built_as: Option[String],
                          extension: String,
                          generated: Boolean,
                          addedByList: String,
                          sourceFile: Option[String],
                          fullPathToObject: Option[String] ) extends BNodeDetails

case class MakefileDetails( makefile: String ) extends BNodeDetails

case class TempReferenceDetails( variable: String,
                                 selectionSuffix: String ) extends BNodeDetails

case class TempCompositeListDetails( listName: String,
                                     suffix: Option[String] ) extends BNodeDetails

case class VariableReferenceDetails( varName: String ) extends BNodeDetails

case class VariableDefinitionDetails( varName: String ) extends BNodeDetails

case class VariableAssignmentDetails( varName: String, op: String, value: String ) extends BNodeDetails

/**
 * Attribute grammar implementation...
 */
trait TreeHelper extends Rewriter with Logging{

  /**
   * Attribute that returns the "Makefile scope" of nodes, i.e. the next
   * Makefile node in the hierarchy (without current node).
   */
  val mfScope: BNode ==> BNode =
    attr{
      case BNode( RootNode, _, _, _ ) =>
        Predef.error( "No containing Makefile found!" )
      case b => b.parent[BNode] match{
        case p@BNode( MakefileBNode, _, _, _ ) => p
        case _ => b.parent[BNode]->mfScope
      }
    }

  /**
   * Attribute that calculates possible predecessors in terms of control and
   * data flow.
   */
  val moveUp: BNode ==> List[BNode] =
    attr{
      case BNode( RootNode, _, _, _ ) => List()
      case b@BNode( TempCompositeListBNode, _, _, TempCompositeListDetails( ln, _ ) ) =>{
        val compositeObjects = findCompositeObjectNodes( ln, b->mfScope )
        val referenceNodes = findTempReferenceNodes( ln, b->mfScope )
        compositeObjects ::: referenceNodes
      }
      case b@BNode( VariableDefinitionBNode, _, _, VariableDefinitionDetails( vN ) ) =>{
        trace("trying to find variable reference, var: " + vN )
        scopedCollectl{
          case b@BNode( VariableReferenceBNode, _, _, VariableReferenceDetails( vRN ) ) if vN == vRN => b
        }( b->mfScope )
      }
      case b:BNode =>{
        trace( "parent of " + node2String(b) + " is: " + node2String(b.parent[BNode])  )
        b.parent[BNode] :: Nil
      }
    }

  private def node2String( b: BNode ) =
    b.ntype.toString + " --> " + PersistenceManager.getDetails( b ).toString

  def findCompositeObjectNodes( listName: String, scope: BNode ): List[BNode] ={
    trace("trying to find comp. object node, list: " + listName )
    scopedCollectl{
      case b@BNode( ObjectBNode, _, _, ObjectDetails( oF, _, _, false, _, None, _ ) ) if oF == listName => b
    }( scope )
  }

	/**
	 * Ignore references in patterns like in crypto/Makefile
	 * crypto_algapi-$(CONFIG_PROC_FS) += proc.o
	 * crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
	 * obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
	 *
	 * i.e. ignore the inclusion of $(list-y) in list-objs, since it's unnecessary and doesn't affect variability conditions (and causes troubles...)
	 *
   */
  def findTempReferenceNodes( name: String, scope: BNode ): List[BNode] =
    scopedCollectl{
      case b@BNode( TempReferenceBNode, _, _, TempReferenceDetails( variable, _ ) )
        if( variable == name && ( b.parent[BNode] match{
          case BNode( _, _, _, TempCompositeListDetails( lN, _ ) ) if lN == variable => false
          case _ => true
        } ) ) => b
    }( scope )

  def getSourceFile( b: BNode ) = b match{
    case BNode( _, _, _, ObjectDetails( _, _, _, _, _, Some( sF ), _ ) ) => sF
    case _ => Predef.error( "Not an ObjectBNode with an associated source file!" )
  }

  def getMakeFile( b: Term ) = b match{
    case BNode( _, _, _, MakefileDetails( mF ) ) => mF
    case _ => Predef.error( "Not a MakefileBNode!" )
  }

  /**
   * Like Kiama's collectl, but stops when it finds a makefile, i.e. the current
   * makefile determines the scope, i.e. the query remains in it.
   */
  def scopedCollectl[T] (f : PartialFunction[Term,T]) : Term => List[T] =
      (t : Term) => {

        trace("# traversing " + getMakeFile(t) )

          var collection = List[T]()
          def collect = (v : T) => {
            trace("   # collecting: " + v.toString )
            collection = collection ::: List (v)
          }
          ( mytd( query( f andThen collect ) ) ) (t)
          collection
      }

  def mytd( s: => Strategy ): Strategy =
    attempt(s) <* visitAllTDExceptMakefiles( mytd( attempt(s) ) )


  /**
   * Visit all children of the term, as long as they aren't Makefiles. Further, the
   * strategy never applies any rewriting, it just runs the given strategy for its
   * side-effects.
   */
  def visitAllTDExceptMakefiles(s : => Strategy): Strategy =
      new Strategy {
          def apply( t: Term ): Option[Term] = {
              t match {
                  case p: Product =>
                    for (i <- 0 until p.productArity)
                      p.productElement (i) match {
                        case b@BNode( MakefileBNode, _, _, _ ) => ;
                        case ct: Term => s(ct)
                        case _ => ;
                      }
                  case _ => ;
              }
            Some( t )
          }
      }


}