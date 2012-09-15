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
 *
 * ./run/core/main.php
 *
 * This is the main file. This file decides, which way
 * the user go. It defines some other needed variables
 * and import needed libaries.
 *
 * Libaries:
 *
 * - Smarty.class.php : Smarty a template engine for PHP.
 *        This template engine helps to cut HTML from PHP
 *        and write HTML in special template-files. This
 *        method is very simple and keeps the code prettier.
 * - textdb.php : A self written text-database. Its used
 *        for managing the user accounts. MySQL or another
 *        database is too overdimensionised for this simple
 *        task ;)
 * - session.php : A self written session-management-class
 *        with some useful methods
 * - tools.php : A set of tools, needed for this project
 *
 * Look in the code for another annotations
 */

//Import some required libaries
require("./run/_lib/smarty/Smarty.class.php");
require("./run/_lib/textdb/textdb.php");
require("./run/core/session.php");
require("./run/core/project_manager.php");

define("TYPE_PROJECT", "project");
define("TYPE_COMPARE", "compareproject");
define("TYPE_DELTA", "deltaproject");
define("FILENAMEENDING_PROJECT", ".project.xml");
define("FILENAMEENDING_COMPARE", ".compare.xml");
define("FILENAMEENDING_DELTA", ".deltaproject.xml");

//Set up the connection to the login database
$textdb_login = new textdb();
$textdb_login->connect("./db/login.db");

//Setting up the project-manager
$projectMan = new project_manager();
$projectMan->TYPE_PROJECT = TYPE_PROJECT;
$projectMan->TYPE_COMPARE = TYPE_COMPARE;
$projectMan->TYPE_DELTA = TYPE_DELTA;
$projectMan->FILENAMEENDING_PROJECT = FILENAMEENDING_PROJECT;
$projectMan->FILENAMEENDING_COMPARE = FILENAMEENDING_COMPARE;
$projectMan->FILENAMEENDING_DELTA = FILENAMEENDING_DELTA;

//Create a Session
$session = new session();
$session->name = WEBSITE_SESSION_NAME;

if(!file_exists($WEBSITE_SESSION_PATH)){
	mkdir($WEBSITE_SESSION_PATH);
}
$session->start($WEBSITE_SESSION_PATH);

//Setting up Smarty
$template = new Smarty();
if(!file_exists("./templates/tpl")){mkdir("./templates/tpl");}
if(!file_exists("./templates/php")){mkdir("./templates/php");}
if(!file_exists("./templates/cfg")){mkdir("./templates/cfg");}
if(!file_exists("./templates/tmp")){mkdir("./templates/tmp");}

$template->template_dir = "./templates/tpl";
$template->compile_dir = "./templates/php";
$template->config_dir = "./templates/cfg";
$template->cache_dir = "./templates/tmp";

//Check website language and set the correct one, if changed
if(isset($_GET['lang']) && ($_GET['lang']=="DE-DE" || $_GET['lang']=="EN-US")){
	$session->set("lang",$_GET['lang']);
}

//The correct language will now be included
if($session->get("lang")!=""){
	require("./lang/".$session->get("lang").".php");
}else{
	//This is the default-language
	require("./lang/EN-US.php");
}

//Read the current URL for language-switch
if(strpos($_SERVER['REQUEST_URI'],"lang=")>0){
	header('Location: '.$WEBSITE_DEFAULT_URI);
}

//Handles redirect-tasks. Example: A language change should be made from all website-situations,
//esp. in the settings or during view a project. The current uri-state will be saved and used
//for the next website-reload
$template->assign("redirectURL",urlencode($_SERVER['REQUEST_URI']));
if(isset($_GET['redirect'])){
	header('Location: '.$_GET['redirect']);
}

//Include all needed things for the navigation pane
require("./run/site/navigation_pane.php");

//Decide which way the user choose
$root = "";
if(isset($_GET['root'])){
	$root = $_GET['root'];
}
switch ($root) {
	case "":
		require("./run/site/main.php");
		break;
	case "reload_tree":
		echo tools::reload_tree();
		require("./run/site/main.php");
		break;
	case "execute":
		require("./run/execute/main.php");
		break;
	case "file":
		require("./run/site/permalink.php");
		break;
	case "login":
		require("./run/account/login.php");
		break;
	case "logout":
		require("./run/account/logout.php");
		break;
	case "project":
		require("./run/project/main.php");
		break;
	case "403_forbidden":
		require("./run/pages/403_forbidden.php");
		break;
	case "404_not_found":
		require("./run/pages/404_not_found.php");
		break;
	case "501_not_implemented":
		require("./run/pages/501_not_implemented.php");
		break;
	default:
		require("./run/pages/404_not_found.php");
		break;
}

$textdb_login->close();

//Defines some variables for Smarty
$template->assign("_website_name", WEBSITE_NAME);
$template->assign("_website_version", WEBSITE_VERSION);
$template->assign("_website_autor", WEBSITE_AUTOR);
$template->assign("_website_year", date("Y",time()));
$template->assign("login", $session->get('login'));
$template->assign("login_username", $session->get('username'));
$template->assign("rights", tools::have_rights());
$template->assign("_wud", $WEBSITE_DEFAULT_URI);
$template->assign("rights", $session->get("rights"));
$template->assign("actual_project_name", $session->get("current_project"));
$template->assign("actual_project_type", $projectMan->getProjectTypeFromGivenProject($session->get("current_project")));
$template->assign("TYPE_PROJECT", TYPE_PROJECT);
$template->assign("TYPE_DELTA", TYPE_DELTA);
$template->assign("TYPE_COMPARE", TYPE_COMPARE);
$template->display("./core/main.tpl");
?>