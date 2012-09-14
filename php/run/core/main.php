﻿<?php

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
if($_GET['lang']=="DE-DE" || $_GET['lang']=="EN-US"){
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
	if(substr($_POST['deltas'],0,1)=="_"){
		$session->set('current_project',substr($_POST['deltas'],1));
	}
	
	$PROJECT_NAME = $session->get('current_project');
	$PROJECT_TYPE = "project";

	//List all projects in the treeview-option-box and
	//get all deltas for all projects
	$handle = opendir($WEBSITE_PROJECT_PATH);
	$file_exist = false;
	$is_a_delta_selected = false;
	$i=0;
	$j=0;
	$k=0;
	while($file = readdir($handle)){
		if(strlen($file)>12){
			$file_ending = substr($file,-12);
			$file_name = substr($file,0,-12);
			if($file_ending==".project.xml"){
				$projects_list[$i]['name'] = $file_name;
				$projects_list[$i]['id'] = $i;
				if($PROJECT_NAME==$file_name){
					$projects_list[$i]['selected'] = true;
					$file_exist = true;
					$PROJECT_TYPE = "project";
				}else{
					$projects_list[$i]['selected'] = false;
				}
				$i++;
			}
			if($file_ending==".compare.xml"){
				$compareprojects_list[$j]['name'] = $file_name;
				$compareprojects_list[$j]['id'] = $j;
				$compareprojects_list[$j]['selected'] = false;
				if($PROJECT_NAME==$file_name){
					$PROJECT_TYPE = "compareproject";
					$compareprojects_list[$j]['selected'] = true;
				}
				$j++;
			}
		}
		if(strlen($file)>17){
			$file_ending = substr($file,-17);
			$file_name = substr($file,0,-17);
			if($file_ending==".deltaproject.xml"){
				$deltaprojects_list[$k]['name'] = $file_name;
				$deltaprojects_list[$k]['id'] = $k;
				if($PROJECT_NAME==$file_name){
					$deltaprojects_list[$k]['selected'] = true;
					$file_exist = true;
					$PROJECT_TYPE = "deltaproject";
					$is_a_delta_selected = true;
				}else{
					$deltaprojects_list[$k]['selected'] = false;
				}
				$k++;
			}
		}
	}
	
	//Check if a delta is selected
	$template->assign("is_a_delta_selected", $is_a_delta_selected);
	
	//Check if the current project were deleted
	if(!$file_exist){
		if(count($projects_list)>0){
			$PROJECT_NAME = $projects_list[0]['name'];
			$projects_list[0]['selected'] = true;
		}
	}
	closedir($handle);

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
	
	//Filter out all deltas, that are not belong to the main
	//project
	if($PROJECT_TYPE=="deltaproject"){
		$proj_name_explode = explode("_",$PROJECT_NAME);
		for($i=0;$i<count($proj_name_explode)-1;$i++){
			$orign_project_name .= "_".$proj_name_explode[$i]; 
		}
		$orign_project_name = substr($orign_project_name,1);
		$template->assign("project_name_origin",$orign_project_name);
		
		for($i=0;$i<count($projects_list);$i++){
			if($orign_project_name==$projects_list[$i]['name']){
				$projects_list[$i]['selected'] = true;
			}else{
				$projects_list[$i]['selected'] = false;
			}
		}
		$template->assign("projects_deltas",$deltaprojects_list);
		$template->assign("projects_deltas_compare",$deltaprojects_list);
	}elseif($PROJECT_TYPE=="project"){
		$j=0;
		for($i=0;$i<count($deltaprojects_list);$i++){
			$delt_name_explode = explode("_",$deltaprojects_list[$i]['name']);
			$orign_delta_name="";
			for($j=0;$j<count($delt_name_explode)-1;$j++){
				$orign_delta_name .= "_".$delt_name_explode[$j]; 
			}
			$orign_delta_name = substr($orign_delta_name,1);

			if($orign_delta_name==$PROJECT_NAME){
				$deltaprojects_list_new[$j]['id'] = $deltaprojects_list[$i]['id'];
				$deltaprojects_list_new[$j]['name'] = $deltaprojects_list[$i]['name'];
				$deltaprojects_list_new[$j]['selected'] = false;
				$j++;
			}
		}
		$template->assign("projects_deltas",$deltaprojects_list_new);
		$template->assign("projects_deltas_compare",$deltaprojects_list_new);
	}elseif($PROJECT_TYPE=="compareproject"){
		for($i=0;$i<count($compareprojects_list);$i++){
			if($compareprojects_list[$i]['selected']==true){
				$PROJECT_NAME = $compareprojects_list[$i]['name'];
			}
		}
		//Setting all option-boxes to the correct values
		for($i=0;$i<count($deltaprojects_list);$i++){
			if($deltaprojects_list[$i]['name']==$_GET['mainproject'] || $deltaprojects_list[$i]['selected']==$_GET['compareproject']){
				$deltaprojects_list[$i]['selected'] = true;
			}else{
				$deltaprojects_list[$i]['selected'] = false;
			}
		}
		for($i=0;$i<count($projects_list);$i++){
			if($projects_list[$i]['name']==$_GET['mainproject'] || $projects_list[$i]['selected']==$_GET['compareproject']){
				$projects_list[$i]['selected'] = true;
			}else{
				$projects_list[$i]['selected'] = false;
			}
		}
		$template->assign("projects_deltas",$deltaprojects_list_new);
		$template->assign("projects_deltas_compare",$deltaprojects_list_new);
	}
	
	$template->assign("projects_list", $projects_list);

	//Checks whether projects are available
	if(count($projects_list)==0){
		$template->assign("project_name", "emptytree/empty");
		$template->assign("login", true);
	}else{
		//Read the current project-settings-file
		$PROJECT_PATH = "";
		$template->assign("project_name", $PROJECT_NAME);
		$template->assign("login", true);
		
		if($PROJECT_TYPE=="project"){
			$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$PROJECT_NAME.".project.xml");
		}elseif($PROJECT_TYPE=="deltaproject"){
			$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$PROJECT_NAME.".deltaproject.xml");
		}elseif($PROJECT_TYPE=="compareproject"){
			$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$PROJECT_NAME.".compare.xml");
		}
		$xml = simplexml_load_string($string);
		
		$PROJECT_PATH = $xml->header->project->path."/";
	}
	
	//Checks if the user want to delete a project
	if($_REQUEST['cmd_delete_project']){
		exec("java -jar ../java/Web_ProjectDelete.jar ".$PROJECT_NAME." ".GLOBAL_SETTINGS);
		header('Location: '.$WEBSITE_DEFAULT_URI.'/');
	}
	
	$template->assign("rights", $session->get("rights"));
	
	//Checks if the user want to compare a project
	if($_REQUEST['cmd_projects_deltas_compare']){
		$act_pro_type = "";
		if($PROJECT_TYPE=="project"){
			$act_pro_type = "P";
		}
		if($PROJECT_TYPE=="deltaproject"){
			$act_pro_type = "D";
		}
		
		$comp_pro_type = "";
		$comp_pro_name = $_POST['deltas_compare'];
		if(substr($_POST['deltas_compare'],0,1)=="_"){
			$comp_pro_type = "P";
			$comp_pro_name = substr($_POST['deltas_compare'],1);
		}else{
			$comp_pro_type = "D";
		}
		
		/* Checks if the compare-file exist already*/
		$project_name_compare = $PROJECT_NAME.$act_pro_type."__".$comp_pro_name.$comp_pro_type;
		$filename_compare = $WEBSITE_PROJECT_PATH."/".$project_name_compare.".compare.xml";
		
		if(!file_exists($filename_compare)){
			shell_exec("java -jar ../java/Web_ProjectCompare.jar ".$PROJECT_NAME." ".$comp_pro_name." ".$session->get("username")." ".GLOBAL_SETTINGS);
			shell_exec("java -jar ../java/Web_TreeViewInitializator.jar ".$project_name_compare." ".GLOBAL_SETTINGS);
		}
		$session->set('current_project',$project_name_compare);
		header('Location: '.$WEBSITE_DEFAULT_URI.'/?mainproject='.$PROJECT_NAME.'&compareproject='.$comp_pro_name);
	}

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