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
require("./run/_lib/geshi/geshi.php");
require("./run/_lib/smarty/Smarty.class.php");
require("./run/_lib/textdb/textdb.php");
require("./run/core/session.php");

//Set up the connection to the login database
$textdb_login = new textdb();
$textdb_login->connect("./db/login.db");

//Create a Session
$session = new session();
$session->name = WEBSITE_SESSION_NAME;
$session->start($WEBSITE_SESSION_PATH);

//Set up Smarty
$template = new Smarty();
$template->template_dir = "./templates/tpl";
$template->compile_dir = "./templates/php";
$template->config_dir = "./templates/cfg";
$template->cache_dir = "./templates/tmp";

//Check if the user is logged in
if($session->get('login')!=true){
	require("./run/account/login.php");
}else{
	if(substr($_POST['project'],0,1)=="_"){
		$session->set('current_project',substr($_POST['project'],1));
	}
	
	$PROJECT_NAME = $session->get('current_project');

	//List all projects in the treeview-option-box
	$handle = opendir($WEBSITE_PROJECT_PATH);
	$i=0;
	while($file = readdir($handle)){
		if(substr($file,-8)==".project"){
			$projects_list[$i]['name'] = substr($file,0,-8);
			$projects_list[$i]['id'] = $i;
			if($PROJECT_NAME==substr($file,0,-8)){
				$projects_list[$i]['selected'] = true;
			}else{
				$projects_list[$i]['selected'] = false;
			}
		}
		$i++;
	}
	closedir($handle);
	$template->assign("projects_list", $projects_list);
	
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