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
package gsd.buildanalysis.linux.test

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import gsd.buildanalysis.linux.model._
import gsd.buildanalysis.linux.{Expression, PCDerivation, Defined, Identifier}

@RunWith(classOf[JUnitRunner])
class PCDerivationTest extends FunSuite with TreeHelper{

  /*
    root
    + /MF1 [defined(MF1)]
      + obj1.o
      + obj2.o
      + MF2 [defined(MF2)]
        + obj1.o
        + obj3.o [defined(obj3)]
      + obj1.o
   */
        val ch2 = BNode( ObjectBNode, Nil, None, ObjectDetails( "obj1", None, "o", false, "obj", None, None ) ) ::
                  BNode( ObjectBNode, Nil, Some( Defined( Identifier("obj3") ) ), ObjectDetails( "obj3", None, "o", false, "obj", Some( "obj3.c" ), None ) ) ::
                  Nil
      val ch1N1 = BNode( ObjectBNode, Nil, None, ObjectDetails( "obj1", None, "o", false, "obj", None, None ) )
      val ch1N2 = BNode( ObjectBNode, Nil, None, ObjectDetails( "obj2", None, "o", false, "obj", Some("obj2.c"), None ) )
      val ch1N3 = BNode( MakefileBNode, ch2, Some( Defined( Identifier("MF2") ) ), MakefileDetails("/MF1/MF2") )
      val ch1N4 = BNode( ObjectBNode, Nil, None, ObjectDetails( "obj1", None, "o", false, "obj", None, None ) )
    val ch1 = ch1N1 :: ch1N2 :: ch1N3 :: ch1N4 :: Nil
  val mf1 = BNode( MakefileBNode, ch1, Some( Defined( Identifier("MF1") ) ), MakefileDetails("/MF1") )
  val ast1 = BNode( RootNode, mf1 :: Nil, None, NoDetails )

  test("Verify scoped traversal"){
    assert( findCompositeObjectNodes( "obj1", mf1 ) === ch1N1 :: ch1N4 :: Nil )
  }

  implicit def string2Identifier( s: String ) = Identifier( s )

  test("Check derived PCs"){
    val pcs = PCDerivation.calculateFilePCs( ast1, Map[String,Expression]() )
    val pc = pcs get "obj3.c"
    assert( pc === Some( Defined( "obj3" ) & ( Defined( "MF2") & Defined( "MF1" ) ) ) )
  }

}