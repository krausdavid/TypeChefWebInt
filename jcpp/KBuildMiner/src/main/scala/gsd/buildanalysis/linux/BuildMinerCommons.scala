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
import java.io.{FileFilter, File}
import gsd.common.Logging

trait BuildMinerCommons extends Rewriter with Logging{

  val toBoolean = everywherebu{
    rule{
      case Or( Eq(Identifier(a),StringLiteral("y")), Eq(Identifier(b),StringLiteral("m")) ) if a==b =>
        Defined(Identifier(a))
      case UnknownExpression( e ) => False()
      case InvalidExpression => False()
    }
  }

  val removeCONFIG_Prefix = everywheretd{
    rule{
      case Identifier( i ) if i startsWith "CONFIG_" => Identifier( i substring 7 )
    }
  }

  /**
   * This method handles some special function calls appearing in some Makefiles, e.g. in /sound/synth/emux/Makefile:
   * the sequencer function is defined:
   * 		sequencer = $(if $(subst y,,$(CONFIG_SND_SEQUENCER)),$(if $(1),m),$(if $(CONFIG_SND_SEQUENCER),$(1)))
   * and it's used over here:
   * 		obj-$(call sequencer,$(CONFIG_SND_SBAWE)) += snd-emux-synth.o
   */
  def rewriteSequenceCallExpressions( e: Expression ) =
    rewrite( sequencerRule )(e)

  private val SequencerCallPattern = "SequencerCall\\[(.+),(.+)\\]_([y|m])".r

  val sequencerRule = everywherebu{
    rule{
      case id@Identifier( i ) => {
        i match{
          case SequencerCallPattern( f, s, ext ) => {
            debug( "SequencerCall matched! " + i + " -> " + f + "," + s + "," + ext )
            ext match{
              case "m" => Eq( Identifier(f), StringLiteral("m") )
              case "y" => Eq( Identifier(f), StringLiteral("y") ) &
                          ( Eq( Identifier(s), StringLiteral("y") ) | Eq( Identifier(s), StringLiteral("m") ) )
              case _   => error( "extension must be y or m" )
            }
          }
          case _ => id
        }
      }
    }
  }

  val sourceOnlyFilter = new FileFilter(){
    def accept( pathName: File ) = pathName.isFile &&
            ( pathName.getName.endsWith( ".c" ) || pathName.getName.endsWith( ".S" ) )
  }
  val dirOnlyFilter = new FileFilter(){
    def accept( pathName: File ) = pathName.isDirectory
  }

}