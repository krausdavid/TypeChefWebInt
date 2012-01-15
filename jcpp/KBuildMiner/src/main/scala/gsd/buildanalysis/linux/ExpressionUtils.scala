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

trait ExpressionUtils extends Rewriter{

  val FALSE: Expression = False()
  val TRUE: Expression = True()

  def simplify( e: Expression ) =
    rewrite( simplifyRule )(e)

  val simplifyRule = innermost{
    rule{
      // some general logical rules
      case Not( Not( a ) )                  => a
      case Not( True() )                    => False()
      case Not( False() )                   => True()
      case Or( a, b ) if a == b             => a
      case Or( True(), a )                  => True()
      case Or( False(), a )                 => a
      case Or( a, True() )                  => True()
      case Or( a, False() )                 => a
      case And( True(), a )                 => a
      case And( False(), a )                => False()
      case And( a, True() )                 => a
      case And( a, False() )                => False()
      case And( a, b ) if a == b            => a
      case And( And( a, b ), c ) if b == c  => And( a, b )
      case And( a, And( b , c )) if a == b  => And( b, c )

      case Or(And(a,b),And(c,d)) if a == c  => And( a, Or( b, d ) )
      case Or(And(a,b),And(c,d)) if b == d  => And( b, Or( a, c ) )
      case Or(And(a,b),And(c,d)) if b == c  => And( b, Or( a, d ) )
      case Or(And(a,b),And(c,d)) if a == d  => And( a, Or( b, c ) )

      case And(Or(a,b),Or(c,d))  if a == c  => Or( a, And( b, d ) )
      case And(Or(a,b),Or(c,d))  if b == d  => Or( b, And( a, c ) )
      case And(Or(a,b),Or(c,d))  if b == c  => Or( b, And( a, d ) )
      case And(Or(a,b),Or(c,d))  if a == d  => Or( a, And( b, c ) )

      case Or( a, And( b, c ) ) if ( a == b || a == c)   => a
      case Or( And( a, b ), c ) if ( a == c || b == c )  => c

      case Or( And( a, b ), Or( c, d ) ) if ( a == c || a == d || b == c || b == d )   => Or( c, d )
      case Or( Or( c, d ), And( a, b ) ) if ( a == c || a == d || b == c || b == d )   => Or( c, d )

      case Or( Not( a ), b ) if a == b => True()
      case Or( a, Not( b ) ) if a == b => True()


      case Implies( a, True() )             => True()
      case Implies( a, b ) if a == b        => True()
      case Implies( a, And(b,c) ) if a == b => Implies( a, c )
      case Implies( a, And(b,c) ) if a == c => Implies( a, b )
      case Implies( a, Or(b,c) ) if a == b  => True()
      case Implies( a, Or(b,c) ) if a == c  => True()
      case Implies( And(a,b), c ) if ( a == c || b == c ) => True()
      case Implies( False(), a )            => True()
      case Implies( a, False() )            => Not( a )
      case Implies( True(), a )             => a

//      case Implies( a, b )                  => Or( Not(a), b )

      // some KBuildMiner-specific simplifications
      case Eq( a, StringLiteral("") )       => Not( Or( Eq( a, StringLiteral("y") ), Eq( a, StringLiteral("m") ) ) )
      case NEq( a, StringLiteral("") )      => Or( Eq( a, StringLiteral("y") ), Eq( a, StringLiteral("m") ) )
    }
  }

}