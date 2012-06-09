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

//Import some required classes
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

//Check website language
$LANG="";
if($_GET['lang']==""){
	$LANG = "EN-US";
}
if($_GET['lang']=="DE-DE" ||$_GET['lang']=="EN-US"){
	$LANG = $_GET['lang'];
}

require("./lang/".$LANG.".php");

//Check if the user is logged in
if($session->get('login')!=true){
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
		if(substr($file,-8)==".project"){
			$projects_list[$i]['name'] = substr($file,0,-8);
			$projects_list[$i]['id'] = $i;
			if($PROJECT_NAME==substr($file,0,-8)){
				$projects_list[$i]['selected'] = true;
				$file_exist = true;
			}else{
				$projects_list[$i]['selected'] = false;
			}
			$i++;
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
			$textdb_login->update("initial_project",$projects_list[0]['name'],"id",$session->get('id'));
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
		
		foreach($xml->global->project[0]->attributes() as $a => $b) {
			if($a=="path"){
				$PROJECT_PATH = $b."/";
			}
		}
	}
	
	//Checks if the user want to delete a project
	if($_REQUEST['cmd_delete_project']){
		exec("java -jar ../java/Web_DeleteProject.jar ".$PROJECT_NAME." ".GLOBAL_SETTINGS);
		header('Location: '.$WEBSITE_DEFAULT_URI.'/?lang='.$session->get("lang"));
	}
	
	$template->assign("JSONTree", tools::read_simple_file($WEBSITE_TREEVIEW_PATH."/".$PROJECT_NAME.".json"));
	
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

$template->assign("_website_name", WEBSITE_NAME);
$template->assign("_website_version", WEBSITE_VERSION);
$template->assign("_website_autor", WEBSITE_AUTOR);
$template->assign("_website_year", date("Y",time()));
$template->assign("login", $session->get('login'));
$template->assign("login_username", $session->get('username'));
$template->assign("_wud", $WEBSITE_DEFAULT_URI);
$template->display("./core/main.tpl");
?>