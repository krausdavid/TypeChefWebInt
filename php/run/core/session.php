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

class session{
	var $name;
	
	function start($session_path){
		session_save_path($session_path);
		session_name($this->name);
		session_start();
	}
	
	function set($index, $value){
		$_SESSION[$index] = $value;
	}
	
	function get($index){
		return $_SESSION[$index];
	}
		
	function kill(){
		$_SESSION = array();
		setcookie(session_name(), "");
		session_destroy();
	}
}
?>