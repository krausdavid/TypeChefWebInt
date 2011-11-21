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

define("WEBSITE_NAME", "NONAME");
define("WEBSITE_VERSION", "0.0.0.0");
define("WEBSITE_AUTOR", "Alexander 'EifX' Eifler, David 'hullleman' Kraus");

//define("WEBSITE_URI_DEFAULT", "http://localhost");
define("WEBSITE_HOME_PAGE_DEFAULT", "/content");
define("WEBSITE_HOME_PAGE_LOGIN", "/");
define("WEBSITE_403_PAGE", "/403_forbidden");
define("WEBSITE_404_PAGE", "/404_not_found");
define("WEBSITE_501_PAGE", "/501_not_implemented");
define("WEBSITE_TEMP_DIRECTORY", "/tmp");

// define("DATABASE_NAME", "NONAME");
// define("DATABASE_HOST", "localhost");
// define("DATABASE_USER", "root");
// define("DATABASE_PASSWORD", "eifxeifx");

require("./run/core/main.php");
?>
