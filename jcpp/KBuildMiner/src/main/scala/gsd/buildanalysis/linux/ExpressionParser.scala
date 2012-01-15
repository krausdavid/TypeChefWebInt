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

import util.parsing.combinator.{ImplicitConversions, JavaTokenParsers}

trait ExpressionParser extends JavaTokenParsers with ImplicitConversions {

  //Adds support to stringLiteral for escaping quotes
  val trueExp = """true""".r ^^ ( x => True() )
  val falseExp = """false""".r ^^ ( x => False() )
  val identifier = """[_a-zA-Z][-_0-9a-zA-Z]*""".r ^^ Identifier
  val lit = ("\""+"""([^"\p{Cntrl}\\]|\\[\\/bfnrt"])*"""+"\"").r ^^ StringLiteral

  val integer : Parser[IntLiteral] =
      "(-)?[0-9]+".r ^^ { case i =>
        try {
          IntLiteral(i.toInt)
        }
        catch {
          case e: NumberFormatException =>
//            println("WARNING: " + e.getMessage + ", rounding to " + Integer.MAX_VALUE)
            IntLiteral(Integer.MAX_VALUE)
        }
      }
//  val integer : Parser[StringLiteral] =
//      "(-)?[0-9]+".r ^^ StringLiteral
  val hex : Parser[StringLiteral] =
      //FIXME currently returns a string
      "0x[0-9a-fA-F]+".r  ^^ StringLiteral

  // FIXME float currently doesn't work, fix later...
  val float : Parser[StringLiteral] =
      """[1-9]\.[0-9]*e+[0-9]+""".r ^^ StringLiteral

  lazy val expr : Parser[Expression] = condExpr

  lazy val condExpr : Parser[Expression] =
    orExpr ~ rep("?" ~> condExpr ~ (":" ~> orExpr)) ^^
      {
        case first~rest => (first /: rest){ case (cond, t~f) =>
          Conditional(cond, t, f)
        }
      }

  lazy val orExpr : Parser[Expression] =
    andExpr ~ ("||" ~> orExpr) ^^ Or | andExpr

  lazy val andExpr : Parser[Expression] =
    eqExpr ~ ("&&" ~> andExpr) ^^ And | eqExpr

  //lazy val spaceExpr =
  //  eqExpr ~ expr ^^ AndExpression | eqExpr

  lazy val eqExpr : Parser[Expression] =
    neqExpr ~ ("==" ~> eqExpr) ^^ Eq | neqExpr

  lazy val neqExpr : Parser[Expression] =
    ineqExpr ~ ("!=" ~> neqExpr) ^^ NEq | ineqExpr

  lazy val ineqExpr =
    arithExpr ~ rep(("<(=)?".r | ">(=)?".r) ~ arithExpr) ^^
      {
        case first~rest => (first /: rest){ case (l, op~r) =>
          op match {
            case "<" => LessThan(l,r)
            case ">" => GreaterThan(l,r)
            case "<=" => LessThanOrEq(l,r)
            case ">=" => GreaterThanOrEq(l,r)
          }
        }
      }

  lazy val arithExpr =
    multExpr ~ rep(("."|"+"|"-") ~ multExpr) ^^
      {
        case first~rest => (first /: rest){ case (l, op~r) =>
          op match {
            case "." => Dot(l,r)
            case "-" => Minus(l,r)
            case "+" => Plus(l,r)
          }
        }
      }

  lazy val multExpr =
  unaryExpr ~ rep(("*"|"/"|"%") ~ unaryExpr) ^^
          {
            case first~rest => (first /: rest){ case (l, op~r) =>
              op match {
                case "*" => Times(l,r)
                case "/" => Div(l,r)
                case "%" => Mod(l,r)
              }
            }
          }

  lazy val unaryExpr =
    rep("!" ^^^ { Not.apply _ } | "--" ^^^ { MinusMinus.apply _ }) ~ funcExpr ^^ {
      case unarys~e => (unarys :\ e) { case (op,r) => op(r) }
    }


  lazy val funcExpr : Parser[Expression] =
    identifier ~ ("(" ~> opt(funcExpr ~ rep("," ~> funcExpr)) <~ ")") ^^
      {
        case Identifier(name)~Some(first~rest) =>
            FunctionCall(name, first :: rest)
        case res => error("Unexpected result: " + res)
      } | factorExpr

  lazy val factorExpr = "(" ~> expr <~ ")" | atomExpr
  lazy val atomExpr = hex | float | lit | integer | trueExp | falseExp | identifier

}

object ExpressionParser extends ExpressionParser {

  def parseString(s : String): Expression = parseAll(expr, s) match {
    case Success(result,_) => result
    case x => error(x.toString)
  }

}