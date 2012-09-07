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
 * ./run/project/main.php
 *
 * This little file decide, which way the user go
 */

switch($_GET['choice']){
	case "view":
		require("./run/project/view.php");
		break;
	case "new":
		require("./run/project/new.php");
		break;
	case "match":
		require("./run/project/match.php");
		break;
	default:
		require("./run/pages/404_not_found.php");
		break;
}
?>