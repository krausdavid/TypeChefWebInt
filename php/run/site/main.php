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
 * ./run/site/main.php
 *
 * The main-site. It displayes the legend.
 */

$template->assign("title", langTXT_homepage.", ".langTXT_project.": ".$session->get('current_project'));
$template->assign("template", "./site/main.tpl"); 
?>