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
 *
 * ./run/account/logout.php
 *
 * This little file do the logout
 */

$session->kill();
$guest_login=true;
require("./run/account/login.php");
header('Location: '.$WEBSITE_DEFAULT_URI.'/');
?>