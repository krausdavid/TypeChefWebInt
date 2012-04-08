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

require("./run/_lib/smarty/Smarty.class.php");
require("./run/_lib/textdb/textdb.php");
require("./run/core/session.php");

$textdb_login = new textdb();
$textdb_login->connect("./db/login.db");

$session = new session();
$session->name = WEBSITE_SESSION_NAME;
$session->start();

$template = new Smarty();
$template->template_dir = "./templates/tpl";
$template->compile_dir = "./templates/php";
$template->config_dir = "./templates/cfg";
$template->cache_dir = "./templates/tmp";

//Test-Zone
$PROJECT_PATH ="";
$string = tools::readXMLFile("../projects/busybox.project.xml");
$xml = simplexml_load_string($string);
foreach($xml->global->project[0]->attributes() as $a => $b) {
    if($a=="path"){
		$PROJECT_PATH = $b."/";
	}
}
//Test-Zone End

if(stripos($_SERVER['HTTP_USER_AGENT'], "MSIE")!==false){
	$template->assign("browser", "MSIE");
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