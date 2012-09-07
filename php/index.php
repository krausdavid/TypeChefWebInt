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
 
ob_start();
error_reporting(0);

header("HTTP/1.1 200 OK");
header("Content-Type: text/html; charset=UTF-8");

require("./init.php");
?>
