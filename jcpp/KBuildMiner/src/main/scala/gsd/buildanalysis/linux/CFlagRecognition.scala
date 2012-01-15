/*
 * Copyright (c) 2011 Thorsten Berger <berger@informatik.uni-leipzig.de>
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
import model._

object CFlagRecognition extends Rewriter with TreeHelper{

  case class EXTRA_CFLAGS( value: String, assignmentOp: String, pc: Option[Expression], belongsTo: String )

  abstract class FileSpecificCFlags
  case class CFLAGS_file( sourceFile: Option[String],
                          value: String,
                          assignmentOp: String,
                          pc: Option[Expression],
                          belongsTo: String ) extends FileSpecificCFlags
  case class CFLAGS_REMOVE_file( sourceFile: Option[String],
                                 value: String,
                                 assignmentOp: String,
                                 pc: Option[Expression],
                                 belongsTo: String ) extends FileSpecificCFlags

  val CFLAGS_file_RE = """CFLAGS_([a-z][a-zA-Z0-9-_]*)\.o""".r
  val CFLAGS_REMOVE_file_RE = """CFLAGS_REMOVE_([a-z][a-zA-Z0-9-_]*)\.o""".r

  def findExtraCFlags( ast: BNode ): List[EXTRA_CFLAGS] =
    collectl{

      case b@BNode( _, _, _, VariableAssignmentDetails( "EXTRA_CFLAGS", op, value ) ) =>
        EXTRA_CFLAGS( value,
                      op,
                      PCDerivation.calculateBNodePC( ast, b ),
                      getBelongsTo( b ) )

    }(ast) sort( _.belongsTo < _.belongsTo )

  def findFileSpecificFlags( ast: BNode ): List[FileSpecificCFlags] =
    collectl{

      case b@BNode( _, _, _, VariableAssignmentDetails( CFLAGS_file_RE( file ), op, value ) ) =>
          CFLAGS_file( lookupSourceNode( file, b ),
                       value,
                       op,
                       PCDerivation.calculateBNodePC( ast, b ),
                       getBelongsTo( b ) )

      case b@BNode( _, _, _, VariableAssignmentDetails( CFLAGS_REMOVE_file_RE( file ), op, value ) ) =>
          CFLAGS_REMOVE_file( lookupSourceNode( file, b ),
                              value,
                              op,
                              PCDerivation.calculateBNodePC( ast, b ),
                              getBelongsTo( b ) )

    }( ast )


  private def getBelongsTo( b: BNode ) =
    (b->mfScope).asInstanceOf[BNode].details.asInstanceOf[MakefileDetails].makefile

  private def lookupSourceNode( file: String, varAssignmentNode: BNode ): Option[String] =
    scopedCollectl{
      case BNode( _,_,_, ObjectDetails(oF,_,_,_,_,Some( sf ),_)) if oF == file => sf
    }( varAssignmentNode->mfScope ) match{
      case fst::rest => Some( fst )
      case Nil => None
    }


}