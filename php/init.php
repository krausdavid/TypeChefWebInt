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

$WEBSITE_DEFAULT_URI = "";

$string = tools::readXMLFile("../global_settings.xml");
$xml = simplexml_load_string($string);
foreach($xml->global->website[0]->attributes() as $a => $b) {
    if($a=="defaultURI"){
		$WEBSITE_DEFAULT_URI = $b;
	}
}

define("WEBSITE_NAME", "TypeChefWebInt");
define("WEBSITE_VERSION", "0.0.2.0");
define("WEBSITE_AUTOR", "Alexander 'EifX' Eifler, David 'hullleman' Kraus");
define("WEBSITE_SESSION_NAME", "session");

define("WEBSITE_403_PAGE", $WEBSITE_DEFAULT_URI."/403_forbidden");
define("WEBSITE_404_PAGE", $WEBSITE_DEFAULT_URI."/404_not_found");
define("WEBSITE_501_PAGE", $WEBSITE_DEFAULT_URI."/501_not_implemented");

require("./run/core/main.php");
?>
