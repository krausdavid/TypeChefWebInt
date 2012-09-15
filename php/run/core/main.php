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

//Gets the current project-type, needs an actual session-object
function getActualProjectType($session,$projectMan){
	return $projectMan->getProjectTypeFromGivenProject($session->get('current_project'));
}

//Check if the user change a project
if(isset($_POST['project']) && substr($_POST['project'],0,1)=="_"){
	$session->set('current_project',substr($_POST['project'],1));
}
if(isset($_POST['deltas']) && substr($_POST['deltas'],0,1)=="_"){
	$session->set('current_project',substr($_POST['deltas'],1));
}

//Read all projects from the project-path and store the information
//into the project-manager
$handle = opendir($WEBSITE_PROJECT_PATH);
$i=0;
while($file = readdir($handle)){
	if(strpos($file,FILENAMEENDING_PROJECT)!==false || strpos($file,FILENAMEENDING_DELTA)!==false || strpos($file,FILENAMEENDING_COMPARE)!==false){
		$file_name = "";
		if(strpos($file,FILENAMEENDING_PROJECT)!==false){
			$file_name = substr($file,0,-strlen(FILENAMEENDING_PROJECT));
		}elseif(strpos($file,FILENAMEENDING_DELTA)!==false){
			$file_name = substr($file,0,-strlen(FILENAMEENDING_DELTA));
		}else{
			$file_name = substr($file,0,-strlen(FILENAMEENDING_COMPARE));
		}
	
		$file_list[$i]['name'] = $file_name;
		$file_list[$i]['id'] = $i;
		$file_list[$i]['selected'] = false;
		if($session->get('current_project')==$file_name){
			$file_list[$i]['selected'] = true;
		}
		$i++;
	}
}
$projectMan->addFilesArr($file_list);

//Check if a delta is selected
$template->assign("is_a_delta_selected", $projectMan->isGivenTypeSelected(TYPE_DELTA));

//Check if the current project is deleted
if(!$projectMan->isExistAGivenProject($session->get('current_project'))){
	$session->set('current_project', $projectMan->getFirstProjectFromAGivenType(TYPE_PROJECT));
	$projectMan->selectAProjectWithGivenProjectName($session->get('current_project'));
}
closedir($handle);


//Check if the given project from the database is exist
if(!$projectMan->isExistAGivenProject($session->get('initial_project'))){
	$new_project = $projectMan->getFirstProjectFromAGivenType(TYPE_PROJECT);
	$template->assign("error_projectDeleted", true);
	$template->assign("error_projectDeleted_project_old", $session->get('initial_project'));
	$template->assign("error_projectDeleted_project_new", $new_project);
	$session->set('initial_project', $new_project);
	$session->set('current_project',$new_project);
	if($session->get("id")!=0 && $session->get("rights")){ //Only active, if an user has logged in
		$textdb_login->update("initial_project",$new_project,"id",$session->get('id'));
	}
}

//Generates the lists for output
$projectMan->projectList_generate();
$projectMan->deltaList_generate();
$projectMan->compareList_generate();

//Filter out all deltas, that are not belong to the main
//project
$orign_project_name = $projectMan->getProjectThatBelongsToAGivenDelta($session->get('current_project'));
$template->assign("project_name_origin",$orign_project_name);

if(getActualProjectType($session,$projectMan)==TYPE_DELTA){
	$projectMan->projectList_selectAnProject($orign_project_name);
}elseif(getActualProjectType($session,$projectMan)==TYPE_COMPARE){
	$projectMan->compareList_selectCorrectEntriesInProjectListAndDeltaList($session->get('current_project'));
}

//Get the correct delta-list
$delt_list = $projectMan->deltaList_getAllDeltasToAGivenProject($session->get('current_project'));
$template->assign("projects_deltas",$delt_list);
$template->assign("projects_deltas_compare",$delt_list);

//Get the project-list
$template->assign("projects_list", $projectMan->projectList_getProjectList());

//Checks whether projects are available 
if($projectMan->projectList_countProjectList()==0){
	$template->assign("project_name", "emptytree/empty");
	$template->assign("login", true);
}else{
	//Read the current project-settings-file
	$PROJECT_PATH = "";
	$template->assign("project_name", $session->get('current_project'));
	$template->assign("login", true);
	
	if(getActualProjectType($session,$projectMan)==TYPE_PROJECT){
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$session->get('current_project').FILENAMEENDING_PROJECT);
	}elseif(getActualProjectType($session,$projectMan)==TYPE_DELTA){
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$session->get('current_project').FILENAMEENDING_DELTA);
	}elseif(getActualProjectType($session,$projectMan)==TYPE_COMPARE){
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$session->get('current_project').FILENAMEENDING_COMPARE);
	}
	$xml = simplexml_load_string($string);
	
	$PROJECT_PATH = $xml->header->project->path."/";
}

//Checks if the user want to delete a project
if(isset($_REQUEST['cmd_delete_project']) && $_REQUEST['cmd_delete_project']){
	exec("java -jar ../java/Web_ProjectDelete.jar ".$session->get('current_project')." ".GLOBAL_SETTINGS);
	header('Location: '.$WEBSITE_DEFAULT_URI.'/');
}

//Checks if the user want to compare a project
if(isset($_REQUEST['cmd_projects_deltas_compare'])){
	$comp_pro_name = $_POST['deltas_compare'];
	
	/* Checks if the compare-file exist already*/
	$project_name_compare = $session->get('current_project')."__".$comp_pro_name;
	$filename_compare = $WEBSITE_PROJECT_PATH."/".$project_name_compare.FILENAMEENDING_COMPARE;

	if(!file_exists($filename_compare)){
		shell_exec("java -jar ".$WEBSITE_DIR_PATH."/java/Web_ProjectCompare.jar ".$session->get('current_project')." ".$comp_pro_name." ".$session->get("username")." ".GLOBAL_SETTINGS);
		shell_exec("java -jar ".$WEBSITE_DIR_PATH."/java/Web_TreeViewInitializator.jar ".$project_name_compare." ".GLOBAL_SETTINGS);
	}

	$session->set('current_project',$project_name_compare);
	header('Location: '.$WEBSITE_DEFAULT_URI.'/?mainproject='.$session->get('current_project').'&compareproject='.$comp_pro_name);
}

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