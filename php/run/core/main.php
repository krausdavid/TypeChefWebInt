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

require("./run/core/tools.php");
//require("./run/_lib/mysql/mysql.php");
require("./run/_lib/smarty/Smarty.class.php");

// $database = new mysql();
// $database->host = DATABASE_HOST;
// $database->user = DATABASE_USER;
// $database->password = DATABASE_PASSWORD;
// $database->name = DATABASE_NAME;
// $database->connect();

$template = new Smarty();
$template->template_dir = "./templates/tpl";
$template->compile_dir = "./templates/php";
$template->config_dir = "./templates/cfg";
$template->cache_dir = "./templates/tmp";

//echo "->".tools::read_settings("typechef_path")."<-";

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
//$database->disconnect();

$template->assign("_website_name", WEBSITE_NAME);
$template->assign("_website_version", WEBSITE_VERSION);
$template->assign("_website_autor", WEBSITE_AUTOR);
$template->assign("_website_year", date("Y",time()));
$template->assign("_wud", WEBSITE_DEFAULT_URI);
$template->display("./core/main.tpl");
?>
