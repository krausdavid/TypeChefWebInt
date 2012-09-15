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
 * ./index.php
 *
 * This is the main file. From this file, all ways goes
 * deeper ;)
 */

if(false){ //Switch for "Under Construction"-Message
	if(!(isset($_GET['under_construction']) && $_GET['under_construction']=="true")){
		echo "<table width=\"100%\"><tr><td align=\"center\">ATTENTION!!! THIS SITE IS UNDER CONSTRUCTION!!! A NORMAL USE IS NOT POSSIBLE FOR NOW!!!<br><br>This site is in not too long time ago online!</td></tr></table>";
		exit;
	}
}

ob_start();
error_reporting(0);

header("HTTP/1.1 200 OK");
header("Content-Type: text/html; charset=UTF-8");

require("./init.php");
?>
