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
 * ./init.php
 *
 * This file defines some needed variables:
 * - WEBSITE_DEFAULT_URI : Gets the standard-URI from
 *        this website. It's needed for all HTML-Links,
 *        because relative Links are not possible.
 * - WEBSITE_SESSION_PATH : The temp-path for stored
 *        sessions
 * - WEBSITE_PROJECT_PATH : This variable stores the
 *        the path, where the generated XML-projects
 *        laid on the disk 
 */

date_default_timezone_set('Europe/Berlin');

require("./run/core/tools.php");

$WEBSITE_DEFAULT_URI = "";
define("GLOBAL_SETTINGS", "/app/home/eifx/public_html/TypeChefWebInt/global_settings.xml"); //TODO: Make dynamic!!! (Maybe in the settings-dialog)

$string = tools::readXMLFile(GLOBAL_SETTINGS);
$xml = simplexml_load_string($string);
foreach($xml->global->website[0]->attributes() as $a => $b) {
    if($a=="defaultURI"){
		$WEBSITE_DEFAULT_URI = $b;
	}
}

$WEBSITE_SESSION_PATH = "";
$WEBSITE_DIR_PATH = "";

$string = tools::readXMLFile(GLOBAL_SETTINGS);
$xml = simplexml_load_string($string);
foreach($xml->global->webint[0]->attributes() as $a => $b) {
    if($a=="path"){
		$WEBSITE_DIR_PATH = $b;
		$WEBSITE_SESSION_PATH = $b."/php/tmp";
	}
}

$WEBSITE_PROJECT_PATH = "";

$string = tools::readXMLFile(GLOBAL_SETTINGS);
$xml = simplexml_load_string($string);
foreach($xml->global->projects[0]->attributes() as $a => $b) {
    if($a=="path"){
		$WEBSITE_PROJECT_PATH = $b;
	}
}

define("WEBSITE_NAME", "TypeChefWebInt");
define("WEBSITE_VERSION", "0.3.0.1");
define("WEBSITE_AUTOR", "Alexander 'EifX' Eifler, David 'hullleman' Kraus");
define("WEBSITE_SESSION_NAME", "session");

define("WEBSITE_403_PAGE", $WEBSITE_DEFAULT_URI."/403_forbidden");
define("WEBSITE_404_PAGE", $WEBSITE_DEFAULT_URI."/404_not_found");
define("WEBSITE_501_PAGE", $WEBSITE_DEFAULT_URI."/501_not_implemented");

require("./run/core/main.php");
?>
