<?php

/*
 * #####################################################
 * #                                                   #
 * # TYPECHEF WEB INTERFACE                            #
 * #                                                   #
 * # Copyright (c) by EifX & KrausDavid                #
 * #                                                   #
 * #                    eifx@informatik.uni-marburg.de #
 * #              krausdavid@informatik.uni-marburg.de #
 * #                                                   #
 * #####################################################
 *
 * ===Notes=============================================
 * There are currently no notes.
 * =====================================================
 */

class session
{
	var $name;
	
	function start()
	{
		session_save_path($WEBSITE_SESSION_PATH);
		session_name($this->name);
		if ($_GET[$this->name]) {
			session_id($_GET[$this->name]);
		}
		session_start();
	}
	
	function set($index, $value)
	{
		$_SESSION[$index] = $value;
	}
	
	function get($index)
	{
		return $_SESSION[$index];
	}
		
	function kill()
	{
		$_SESSION = array();
		setcookie(session_name(), "");
		session_destroy();
	}
}
?>