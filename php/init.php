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
 */
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

$string = tools::readXMLFile(GLOBAL_SETTINGS);
$xml = simplexml_load_string($string);
foreach($xml->global->webint[0]->attributes() as $a => $b) {
    if($a=="path"){
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
define("WEBSITE_VERSION", "0.2.4.2");
define("WEBSITE_AUTOR", "Alexander 'EifX' Eifler, David 'hullleman' Kraus");
define("WEBSITE_SESSION_NAME", "session");

define("WEBSITE_403_PAGE", $WEBSITE_DEFAULT_URI."/403_forbidden");
define("WEBSITE_404_PAGE", $WEBSITE_DEFAULT_URI."/404_not_found");
define("WEBSITE_501_PAGE", $WEBSITE_DEFAULT_URI."/501_not_implemented");

require("./run/core/main.php");
?>
