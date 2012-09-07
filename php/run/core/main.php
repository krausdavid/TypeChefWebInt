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

//Set up the connection to the login database
$textdb_login = new textdb();
$textdb_login->connect("./db/login.db");

//Create a Session
$session = new session();
$session->name = WEBSITE_SESSION_NAME;

if(!file_exists($WEBSITE_SESSION_PATH)){
	mkdir($WEBSITE_SESSION_PATH);
}
$session->start($WEBSITE_SESSION_PATH);

//Set up Smarty
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
if($_GET['lang']=="DE-DE" ||$_GET['lang']=="EN-US"){
	$session->set("lang",$_GET['lang']);
}

if($session->get("lang")!=""){
	require("./lang/".$session->get("lang").".php");
}else{
	require("./lang/EN-US.php");
}

//Check, if user has switched between "Show Errors" and "Show no Errors"
if($_POST['chk_showOnlyErrors']=="checked" && $_POST['showOnlyErrors_val']=="val"){
	$session->set("showOnlyErrors",true);
}
if($_POST['chk_showOnlyErrors']=="" && $_POST['showOnlyErrors_val']=="val"){
	$session->set("showOnlyErrors",false);
}
$template->assign("showOnlyErrors", $session->get("showOnlyErrors"));

//Read the current URL for language-switch
if(strpos($_SERVER['REQUEST_URI'],"lang=")>0){
	header('Location: '.$WEBSITE_DEFAULT_URI);
}

//Handles redirect-tasks. Example: A language change should be made from all website-situations,
//esp. in the settings or during view a project. The current uri-state will be saved and used
//for the next website-reload
$template->assign("redirectURL",urlencode($_SERVER['REQUEST_URI']));
if($_GET['redirect']!=""){
	header('Location: '.$_GET['redirect']);
}

//Check if the user is logged in
if($session->get('login')!=true){
	$guest_login=true;
	require("./run/account/login.php");
}else{

	//Check if the user change a project
	if(substr($_POST['project'],0,1)=="_"){
		$session->set('current_project',substr($_POST['project'],1));
	}
	
	$PROJECT_NAME = $session->get('current_project');

	//List all projects in the treeview-option-box
	$handle = opendir($WEBSITE_PROJECT_PATH);
	$file_exist = false;
	$i=0;
	while($file = readdir($handle)){
		if(strlen($file)>12){
			if(substr($file,-12)==".project.xml"){
				$projects_list[$i]['name'] = substr($file,0,-12);
				$projects_list[$i]['id'] = $i;
				if($PROJECT_NAME==substr($file,0,-12)){
					$projects_list[$i]['selected'] = true;
					$file_exist = true;
				}else{
					$projects_list[$i]['selected'] = false;
				}
				$i++;
			}
		}
	}
	//Check if the current project were deleted
	if(!$file_exist){
		if(count($projects_list)>0){
			$PROJECT_NAME = $projects_list[0]['name'];
			$projects_list[0]['selected'] = true;
		}
	}

	closedir($handle);
	$template->assign("projects_list", $projects_list);
	

	//Check if the given project from the database is exist
	if(count($projects_list)!=0){
		$isACurrentProject = false;
		for($i=0;$i<count($projects_list);$i++){
			if($projects_list[$i]['name']==$session->get('initial_project')){
				$isACurrentProject = true;
			}
		}
		if($isACurrentProject==false){
			$template->assign("error_projectDeleted", true);
			$template->assign("error_projectDeleted_project_old", $session->get('initial_project'));
			$template->assign("error_projectDeleted_project_new", $projects_list[0]['name']);
			$session->set('initial_project', $projects_list[0]['name']);
			$session->set('current_project', $projects_list[0]['name']);
			$PROJECT_NAME = $projects_list[0]['name'];
			if($session->get("id")!=0){
				$textdb_login->update("initial_project",$projects_list[0]['name'],"id",$session->get('id'));
			}
		}
	}
	
	//Checks whether projects are available
	if(count($projects_list)==0){
		$template->assign("project_name", "emptytree/empty");
		$template->assign("login", true);
	}else{
		//Read the current project-settings-file
		$PROJECT_PATH = "";
		$template->assign("project_name", $PROJECT_NAME);
		$template->assign("login", true);
		
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$PROJECT_NAME.".project.xml");
		$xml = simplexml_load_string($string);
		
		$PROJECT_PATH = $xml->header->project->path."/";
	}
	
	//Checks if the user want to delete a project
	if($_REQUEST['cmd_delete_project']){
		exec("java -jar ../java/Web_DeleteProject.jar ".$PROJECT_NAME." ".GLOBAL_SETTINGS);
		header('Location: '.$WEBSITE_DEFAULT_URI.'/');
	}
	
	$template->assign("rights", $session->get("rights"));
	
	//Decide which way the user choose
	switch ($_GET['root']) {
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
$template->display("./core/main.tpl");
?>