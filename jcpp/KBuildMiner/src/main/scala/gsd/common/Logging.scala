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
package gsd.common

import org.slf4j.LoggerFactory

trait Logging{

  private val log = LoggerFactory.getLogger( getClass )

  def error( message: =>String, values:Object* ) =
    if( log isErrorEnabled )
      log error( message, values )
	def error( message: =>String, error: Throwable ) =
    if( log isErrorEnabled )
      log error( message, error )
	def error( message: =>String, error: Throwable, values: Object ) =
		if( log isErrorEnabled )
      log error( message, error, values )

	def warn( message: =>String, values: Object* ) =
    if( log isWarnEnabled )
      log warn( message, values )
	def warn( message: =>String, error: Throwable ) =
    if( log isWarnEnabled )
      log warn( message, error )
	def warn( message: =>String, error: Throwable, values: Object* ) =
		if( log isWarnEnabled )
      log warn( message, error, values )

  def info( message: =>String, values:Object* ) =
    if( log isInfoEnabled )
      log info( message, values )
	def info( message: =>String, error: Throwable ) =
    if( log isInfoEnabled )
      log info( message, error )
	def info( message: =>String, error: Throwable, values: Object* ) =
		if( log isInfoEnabled )
      log info( message, error, values )

  def debug( message: =>String, values: Object* ) =
    if( log isDebugEnabled )
      log debug( message, values )
  def debug( message: =>String, error: Throwable ) =
    if( log isDebugEnabled )
      log debug( message, error )
  def debug( message: =>String, error: Throwable, values: Object* ) =
    if( log isDebugEnabled )
      log debug( message, error, values )

	def trace( message: =>String, values: Object* ) =
    if( log isTraceEnabled )
      log trace( message, values )
	def trace( message: =>String, error: Throwable ) =
    if( log isTraceEnabled )
      log trace( message, error )
	def trace( message: =>String, error: Throwable, values: Object* ) =
		if( log isTraceEnabled )
      log trace( message, error, values )

}