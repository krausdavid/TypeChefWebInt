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

if($_REQUEST['cmd_submit']){
	if($_POST['txt_name']==$textdb_login->select_once("username",$_POST['txt_name'],"username")){
		if(md5($_POST['txt_password'])==$textdb_login->select_once("username",$_POST['txt_name'],"pwd")){
			$session->set("login", true);
			$session->set("id", $textdb_login->select_once("username",$_POST['txt_name'],"id"));
			$session->set("username", $textdb_login->select_once("username",$_POST['txt_name'],"username"));
			$session->set("initial_project", $textdb_login->select_once("username",$_POST['txt_name'],"initial_project"));
			$session->set("current_project", $textdb_login->select_once("username",$_POST['txt_name'],"initial_project"));
			header('Location: '.$WEBSITE_DEFAULT_URI.'/');
		}
	}
}
 
$template->assign("title", "Login");
$template->assign("template", "./account/login.tpl"); 
?>