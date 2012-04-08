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
	if($_POST['txt_name']==$textdb->select_once("username",$_POST['txt_name'],"username")){
		if($_POST['txt_password']==md5($textdb->select_once("username",$_POST['txt_name'],"pwd"))){
			$session->set("login", true);
			$session->set("id", $textdb->select_once("username",$_POST['txt_name'],"id"));
			$session->set("username", $textdb->select_once("username",$_POST['txt_name'],"username"));
			$session->set("initial_project", $textdb->select_once("username",$_POST['txt_name'],"initial_project"));
			header('Location: '.$WEBSITE_DEFAULT_URI.'/');
		}
	}
}
 
$template->assign("title", "Login");
$template->assign("template", "./account/login.tpl"); 
?>