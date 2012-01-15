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
package gsd.buildanalysis.linux

import kiama.rewriting.Rewriter
import gsd.common.Logging
import model._
import xml.{UnprefixedAttribute, Elem, Node, XML}
import java.io.InputStream
import gsd.buildanalysis.linux.CFlagRecognition.{CFLAGS_REMOVE_file, CFLAGS_file, FileSpecificCFlags, EXTRA_CFLAGS}

object PersistenceManager extends Rewriter with Logging{

  implicit def pimp( elem: Elem ) = new {
    import scala.xml.Null
    def %( attrs: Map[String,String] ) = {
      val seq = for( (n,v) <- attrs ) yield new UnprefixedAttribute( n, v, Null )
      ( elem /: seq ) ( _ % _ )
    }
  }

  def outputXML( root: BNode, targetFile: String ) {
    info( "Saving Build AST to: " + targetFile )
    XML.save( targetFile, getXml( root ) )
  }

  private def getXml( bn: BNode ): Node = ( bn match{
    case BNode( RootNode, ch, _, _ ) => <BuildRoot>{ getXml(ch) }</BuildRoot>
    case BNode( MakefileBNode, ch, _, _ ) => <Makefile>{ getXml(ch) }</Makefile>
    case BNode( IfBNode, ch, _, _ ) => <If>{ getXml(ch) }</If>
    case BNode( ObjectBNode, ch, _, _ ) => <Object>{ getXml(ch) }</Object>
    case BNode( TempReferenceBNode, ch, _, _ ) => <TempReference>{ getXml(ch) }</TempReference>
    case BNode( TempCompositeListBNode, ch, _, _ ) => <TempCompositeList>{ getXml(ch) }</TempCompositeList>
    case BNode( VariableDefinitionBNode, ch, _, _ ) => <ListVariableDefinition>{ getXml(ch) }</ListVariableDefinition>
    case BNode( VariableReferenceBNode, ch, _, _ ) => <VariableReference>{ getXml(ch) }</VariableReference>
    case BNode( VariableAssignmentBNode, ch, _, _ ) => <VariableAssignment>{ getXml(ch) }</VariableAssignment>
    case n => Predef.error( "Unknown node: " + n )
  } ) % getDetails( bn )

  private def getXml( ch: List[BNode] ): Seq[Node] = ch map getXml

  def getDetails( b: BNode ): Map[String,String] = b match{
    case BNode( _, _, exp, details ) => m( exp, "expr" ) ++ ( details match{
      case MakefileDetails( mf ) =>
        m( mf, "path" )
      case ObjectDetails( oF, bA, ext, gen, lN, sF, fP ) =>
        m( oF, "objectFile" ) ++ m( bA, "builtAs" ) ++
        m( ext, "extension" ) ++ m( gen, "generated" ) ++
        m( lN, "listName" ) ++ m( sF, "sourceFile" ) ++
        m( fP, "fullPathToObject" )
      case TempReferenceDetails( v, sS ) =>
        m( v, "variable" ) ++ m( sS, "selectionSuffix" )
      case TempCompositeListDetails( lN, s ) =>
        m( lN, "listName" ) ++ m( s, "suffix" )
      case VariableReferenceDetails( varName ) =>
        m( varName, "varName" )
      case VariableDefinitionDetails( varName ) =>
        m( varName, "varName" )
      case VariableAssignmentDetails( n, o, v ) =>
        m( n, "name" ) ++ m( o, "op" ) ++ m( v, "value" )
      case _ => Map.empty
    } )
  }
  
  private def m[A]( v: Option[A], label: String ): Map[String,String] = v match{
    case Some( x ) => m( x, label )
    case None => Map.empty
  }

  private def m[A]( v: A, label: String ): Map[String,String] = v match{
    case e:Expression => Map( label -> pp( e ) )
    case _ => Map[String,String]( label -> v.toString )
  }

  def loadManualPCs( is: InputStream ): Map[String,Expression] = {
    var ret = Map[String,Expression]()
    val xml = XML load is
    for( x <- xml.child )
      x match{
        case <pc>{ _* }</pc> =>
          ret += ( (x\"f").text -> ExpressionParser.parseString( (x\"e").text ) )
        case _ => ;
      }
    ret
  }

  def saveCFlags( extra_cflags: List[EXTRA_CFLAGS], fsFlags: List[FileSpecificCFlags], targetFile: String ){

    val cflags_file = fsFlags filter( _.isInstanceOf[CFLAGS_file] ) map( _.asInstanceOf[CFLAGS_file] )
    val cflags_remove_file = fsFlags filter( _.isInstanceOf[CFLAGS_REMOVE_file] ) map( _.asInstanceOf[CFLAGS_REMOVE_file] )

    val xml = <cflags>
      <EXTRA_CFLAGS_Assignments>{
        extra_cflags map{ x =>
          ( x, <EXTRA_CFLAGS value={x.value} op={x.assignmentOp} belongsTo={x.belongsTo}/> )
        } map { _ match {
          case ( EXTRA_CFLAGS(_,_,Some(pc),_), n ) => n % Map( ( "pc" -> pp( pc ) ) )
          case ( _, n ) => n
        }}
      }</EXTRA_CFLAGS_Assignments>
      <CFLAGS_file.o>{
        cflags_file map{ x =>
          ( x, <CFLAGS value={x.value} op={x.assignmentOp} belongsTo={x.belongsTo}/> )
        } map { _ match {
          case ( y@CFLAGS_file( Some(sf),_,_,_,_), n ) => ( y, n % Map( ( "sourceFile" -> sf ) ) )
          case ( y, n ) => (y,n)
        }} map{ _ match {
          case ( CFLAGS_file( _,_,_,Some(pc),_), n ) => n % Map( ( "pc" -> pp( pc ) ) )
          case ( _, n ) => n
        }}
      }</CFLAGS_file.o>
      <CFLAGS_REMOVE_file.o>{
        cflags_remove_file map{ x =>
          ( x, <CFLAGS_REMOVE value={x.value} op={x.assignmentOp} belongsTo={x.belongsTo}/> )
        } map { _ match {
          case ( y@CFLAGS_REMOVE_file( Some(sf),_,_,_,_), n ) => ( y, n % Map( ( "sourceFile" -> sf ) ) )
          case ( y, n ) => (y,n)
        }} map{ _ match {
          case ( CFLAGS_REMOVE_file( _,_,_,Some(pc),_), n ) => n % Map( ( "pc" -> pp( pc ) ) )
          case ( _, n ) => n
        }}
      }</CFLAGS_REMOVE_file.o>
    </cflags>

    XML.save( targetFile, xml )
  }

  /**
   * pretty print expression
   */
  def pp( e: Expression ): String = e match{
    case BinaryExpression( a, b, s )  => "(" + pp(a) + " " + s + " " + pp(b) + ")"
    case UnaryExpression( a, s )      => s + pp(a)
    case UnknownExpression( e )       => "Unknown(" + pp(e) + ")"

    case Identifier( i )              => i
    case Defined( id )                => pp( id )
//    case Defined( id )                => "defined(" + pp( id ) + ")"
    case IntLiteral( v )              => v toString
    case StringLiteral( v )           => "\"" + v + "\""

    case True()                       => "[TRUE]"
    case False()                      => "[FALSE]"

    case _                            => e toString
  }

}