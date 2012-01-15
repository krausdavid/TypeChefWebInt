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

import java.io.File
import gsd.buildanalysis.linux.model.{TreeHelper, MakefileDetails, BNode}
import gsd.buildanalysis.linux.{PersistenceManager, Expression, Project}

class BusyBoxProject( basedir: String ) extends Project( basedir ) with TreeHelper{

  val TOP_MAKEFILE_FOLDERS = "applets" :: "archival" :: "archival/libarchive" :: "console-tools" ::
                             "coreutils" :: "coreutils/libcoreutils" :: "debianutils" :: "e2fsprogs" ::
                             "editors" :: "findutils" :: "init" :: "libbb" :: "libpwdgrp" :: "loginutils" ::
                             "mailutils" :: "miscutils" :: "modutils" :: "networking" :: "networking/libiproute" ::
                             "networking/udhcp" :: "printutils" :: "procps" :: "runit" :: "selinux" ::
                             "shell" :: "sysklogd" :: "util-linux" :: "util-linux/volume_id" :: Nil

  val OVERRIDE_Folder = Some( "override/busybox" )

  def getTopMakefileFolders: List[String] = TOP_MAKEFILE_FOLDERS

  def getLocalOverrideFolder = OVERRIDE_Folder

  def lookupSubMakefile( currentMakefile: String, relativePath: String): List[String] = {

    val currentFolder = currentMakefile.substring( 0, currentMakefile.lastIndexOf('/') )
    val newPath = currentFolder + "/" + relativePath

    findMakefile( newPath ) match{
      case m:List[String] if !m.isEmpty => m
      case Nil => Predef.error( "Neither a KBuild nor a Makefile exists in folder " + newPath )
    }
    
  }

  /**
   * Lookup source file of object node
   */
  def getSource( b: BNode, oF: String, gen: Boolean ): Option[String] ={

    val mf = b->mfScope match{
      case BNode(_,_,_,MakefileDetails(m)) => m
      case _ => Predef.error( "No Makefile node!" )
    }

    val currentFolder = if( oF startsWith "/" )
        "" // absolute object path
      else
        mf.substring( 0, mf lastIndexOf '/' )

    // check that source file paths don't start with one or more "/"
    def sanitize( f: String ): String =
      if( f startsWith "/" ) sanitize(f substring 1) else f

    val cPath = currentFolder + "/" + oF + ".c"
    val c = new File( basedir + "/" + cPath )
    if( c.exists || gen ) // safe assumption, since no assembler files are generated
      Some( sanitize( cPath ) )
    else{
      // check for assembler source
      val asmPath = currentFolder + "/" + oF + ".S"
      val a = new File( basedir + "/" + asmPath )
      if( a exists )
        Some( sanitize( asmPath ) )
      else
        None
    }

  }

  def getManualPCs: Map[String,Expression] =
    PersistenceManager loadManualPCs getClass.getResourceAsStream( "/override/busybox_pcs.xml" )

}