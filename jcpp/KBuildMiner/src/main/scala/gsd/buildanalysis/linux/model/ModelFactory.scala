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

import gsd.common.Logging
import gsd.buildanalysis.linux.{ExpressionUtils, Expression, Project}

class ModelFactory( currentMakefileNode: BNode, proj: Project ) extends Logging with ExpressionUtils{

  val makefilePath = currentMakefileNode match{
    case BNode( MakefileBNode, _, _, MakefileDetails( m ) ) => m
    case _ => Predef.error("Not a Makefile node!")
  }

  var currentLoc = NodeLoc( currentMakefileNode )

  def pushIf( exp: Expression ){
    trace( "pushIf" )
    // add new IfNode and set the focus to it
    currentLoc = ( currentLoc :\+ BNode( IfBNode, List(), Some( exp ), NoDetails ) ).downLastOp.get
    trace( "currentLoc=" + currentLoc )
  }

  def pushElse{
    trace( "pushElse" )
    currentLoc.node match{
      case BNode( IfBNode, _, Some( exp ), _ ) => {
        // :+ automatically moves to new location
        currentLoc = currentLoc :+ BNode( IfBNode, List(), Some( !exp ), NoDetails )
      }
      case _ => Predef.error( "Found ELSE without prior IF statement!" )
    }
  }

  def popEndIf = { trace("popEndIf"); pop}
  def popTempCompositeList = { trace("popTempCompositeList"); pop }

  private def pop{
    currentLoc = currentLoc.upOpt match{
      case Some( l ) => l
      case None => Predef.error( "Cannot go up any further!" )
    }
  }

  def addObject( objectFile: String, built_as: String, extension: String, generated: Boolean, listName: String, exp: Expression ){
    trace( "addObject" )
    currentLoc = currentLoc :\+ BNode( ObjectBNode, List(), Some( exp ),
      ObjectDetails( objectFile, Some( built_as ), extension, generated, listName, None, None ) )
  }

  def addObject( objectFile: String, extension: String, generated: Boolean, listName: String, exp: Expression ){
    trace( "addObject" )
    currentLoc = currentLoc :\+ BNode( ObjectBNode, List(), Some( exp ),
      ObjectDetails( objectFile, None, extension, generated, listName, None, None ) )
  }

  def addMakefile( folder: String, exp: Expression ){
    trace( "addMakefile" )
    proj.lookupSubMakefile( makefilePath, folder ) foreach{ mf =>
      currentLoc = currentLoc :\+ BNode( MakefileBNode, List(), Some( exp ),
        MakefileDetails( mf ) )
    }
  }

  def addTempReference( variable: String, selectionSuffix: String, exp: Expression ){
    trace( "addTempReferenceNode")
    currentLoc = currentLoc :\+ BNode( TempReferenceBNode, List(), Some( exp ),
      TempReferenceDetails( variable, selectionSuffix ) )
  }

  def addTempCompositeList( listName: String, suffix: String ){
    trace( "addTempCompositeList" )
    currentLoc = ( currentLoc :\+ BNode( TempCompositeListBNode, List(), None,
      TempCompositeListDetails( listName, Some( suffix ) ) ) ).downLastOp.get
    // all elements will be nested under this one, until we're done with parsing this list
    // (and call popTempCompositeList), thus, we set the focus down to the new node
  }

  def addTempCompositeList( listName: String ){
    trace( "addTempCompositeList" )
    currentLoc = ( currentLoc :\+ BNode( TempCompositeListBNode, List(), None,
      TempCompositeListDetails( listName, None ) ) ).downLastOp.get
    // all elements will be nested under this one, until we're done with parsing this list
    // (and call popTempCompositeList), thus, we set the focus down to the new node
  }

  def addVariableReference( varName: String, exp: Expression ){
    trace( "addVariableReference" )
    currentLoc = currentLoc :\+ BNode( VariableReferenceBNode, List(), Some( exp ),
      VariableReferenceDetails( varName ) )
  }

  def pushListVariable( varName: String ){
    trace( "pushListVariable: " + varName )
    currentLoc = ( currentLoc :\+ BNode( VariableDefinitionBNode, List(), None,
      VariableDefinitionDetails( varName ) ) ).downLastOp.get
    trace( "currentLoc=" + currentLoc.node.ntype )
  }

  def addObjectToList( name: String ){
    trace( "addObjectToList: " + name )
    assert( currentLoc.node.ntype == VariableDefinitionBNode )
    val listName = currentLoc.node.details match{
      case VariableDefinitionDetails( vN ) => vN
      case _ => Predef.error( "Current node is not a list, i.e. a variable definition" )
    }
    currentLoc = currentLoc :\+ BNode( ObjectBNode, List(), Some( TRUE ),
      ObjectDetails( name, None, "o", false, listName, None, None ) )
  }

  def addVariableAssignment( name: String, op: String, value: String ){
    trace(" addVariableAssignment: " + name + ", value: " + value )
    currentLoc = currentLoc :\+ BNode( VariableAssignmentBNode, List(), None,
      VariableAssignmentDetails( name, op, value ) )
  }

  def popListVariable = { trace("popListVariable"); pop }


  def root = currentLoc.top.node

}
