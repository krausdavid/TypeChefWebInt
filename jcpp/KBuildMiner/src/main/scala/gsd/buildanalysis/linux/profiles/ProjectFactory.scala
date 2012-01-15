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
package gsd.buildanalysis.linux.profiles

import gsd.buildanalysis.linux.Project

/**
 * Tries to identify the target project and instantiates an appropriate Project class.
 */
object ProjectFactory{

  val linux = """(?i)^.*linux.*$""".r
  val busybox = """(?i)^.*busybox.*$""".r

  def newProject( basedir: String ): Project = {
    basedir match{
      case linux() => new LinuxProject( basedir )
      case busybox() => new BusyBoxProject( basedir )
      case _ => Predef.error( "Unknown project in: " + basedir )
    }
  }

}