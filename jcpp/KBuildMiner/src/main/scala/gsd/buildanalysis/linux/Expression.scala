/*
 * Copyright (c) 2010 Steven She <shshe@gsd.uwaterloo.ca>
 * and Thorsten Berger <berger@informatik.uni-leipzig.de>
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

sealed abstract class Expression{
  def & (other : Expression) : Expression = other match{
    case True() => this
    case _ => And(this, other)
  }
  def | (other : Expression) : Expression = other match{
    case False() => this
    case _ => Or(this, other)
  }
  def unary_! = Not(this)
  def implies (other : Expression) : Expression = Implies(this, other)

  def splitConjunctions : List[Expression] = this match {
    case And(x,True()) => x.splitConjunctions
    case And(True(),y) => y.splitConjunctions
    case And(x,y) => x.splitConjunctions ++ y.splitConjunctions
    case x => List(x)
  }

}

/**
 * Denotes expressions that are either invalid or the parser
 * doesn't recognize them.
 */
case class InvalidExpression() extends Expression

/**
 * Denotes expressions that we might be able to
 * resolve later with heuristics
 */
case class UnknownExpression( e: Expression ) extends Expression

case class Identifier( name: String ) extends Expression
case class StringLiteral(value : String) extends Expression
case class IntLiteral(value : Int) extends Expression
case class Defined( id: Identifier ) extends Expression

case class Conditional(cond : Expression,
                       pass : Expression,
                       fail : Expression) extends Expression

case class UnaryExpression(e : Expression,
                                      op : String) extends Expression {
  override def toString = op + e
}

case class BinaryExpression(l : Expression,
                                       r : Expression,
                                       op : String) extends Expression {
  override def toString = "(" + l + " "  + op + " " + r + ")"
}

case class Or(left : Expression, right : Expression)
        extends BinaryExpression(left, right, "||")
case class And(left : Expression, right : Expression)
        extends BinaryExpression(left, right, "&&")

case class Eq(left : Expression, right : Expression)
        extends BinaryExpression(left, right, "==")
case class NEq(left : Expression, right : Expression)
        extends BinaryExpression(left, right, "!=")

case class LessThan(left : Expression, right : Expression)
        extends BinaryExpression(left, right, "<")
case class LessThanOrEq(left : Expression, right : Expression)
        extends BinaryExpression(left, right, "<=")
case class GreaterThan(left : Expression, right : Expression)
        extends BinaryExpression(left, right, ">")
case class GreaterThanOrEq(left : Expression, right : Expression)
        extends BinaryExpression(left, right, ">=")

case class Plus(left :Expression, right : Expression)
        extends BinaryExpression(left, right, "+")
case class Minus(left :Expression, right : Expression)
        extends BinaryExpression(left, right, "-")
case class Dot(left : Expression, right : Expression)
        extends BinaryExpression(left, right, ".")

case class Times(left :Expression, right : Expression)
        extends BinaryExpression(left, right, "*")
case class Div(left :Expression, right : Expression)
        extends BinaryExpression(left, right, "/")
case class Mod(left :Expression, right : Expression)
        extends BinaryExpression(left, right, "%")

case class MinusMinus(expr : Expression)
        extends UnaryExpression(expr, "--")
case class Not(expr : Expression)
        extends UnaryExpression(expr, "!")

case class FunctionCall(name : String, arguments : List[Expression]) extends Expression{
  override def toString() = name + "(" + arguments.foldLeft("")( (a,b) => a + ( if( a!="" ) "," else "" ) + b ) + ")"
}


// added for boolean transformation
case class Implies(left : Expression, right:Expression)
      extends BinaryExpression(left, right, "->")

case class True() extends Expression{
  override def & (other: Expression) = other
  override def implies (other: Expression) = other
  override def toString = "TRUE"
}
case class False() extends Expression{
  override def | (other : Expression) = other
  override def toString = "FALSE"
}