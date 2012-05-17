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
$template->assign("langERR_403Forbidden", "FORBIDDEN");
$template->assign("langERR_403NotFound", "NOT FOUND");
$template->assign("langERR_501NotImplemented", "NOT IMPLEMENTED");
$template->assign("langERRTXT_403ErrorMessage", "Sorry, but on this site, you have no access<br><br>You do not have the necessary rights to view the content of this page.");
$template->assign("langERRTXT_404ErrorMessage", "Sorry, but this page you have chosen is not available.<br><br>Probably there is an error in the called link or the area is temporarily unavailable.");
$template->assign("langERRTXT_501ErrorMessage", "Sorry, but this site is not yet full developed.<br><br>We try to make this area as quickly as possible ready.");
$template->assign("langERRTXT_wrongLogin", "Wrong login! Username / Password are not correct.");

$template->assign("langINF_information", "Information");

$template->assign("langINFTXT_deletedProject_PART1", "Your current project has been removed. You been redirected from");
$template->assign("langINFTXT_deletedProject_PART2", "to");
$template->assign("langINFTXT_deletedProject_PART3", ". This project has been marked as favorite.");

$template->assign("langTXT_actualProject", "Actual project");
$template->assign("langTXT_compareTwoProjects", "Compare two projects");
$template->assign("langTXT_hello", "Hello");
$template->assign("langTXT_homepage", "Home");
$template->assign("langTXT_login", "Login");
$template->assign("langTXT_logout", "Logout");
$template->assign("langTXT_name", "Name");
$template->assign("langTXT_newProject", "New projekt...");
$template->assign("langTXT_noProjectsExist", "No projects exist");
$template->assign("langTXT_options", "Options");
$template->assign("langTXT_password", "Password");
$template->assign("langTXT_projects", "Projects");
$template->assign("langTXT_pleaseActivateJavaScript", "Please activate JavaScript!");
$template->assign("langTXT_settings", "Settings");

$template->assign("langTXTHOME_topic", "Hello and welcome at TypeChefWebInt");
$template->assign("langTXTHOME_descripton", "On the left side you see an current loaded project. You can navigate through the tree and you can display a group of files of your choice. Once you have chosen a group of files, you can opt for a particular file.");
$template->assign("langTXTHOME_legendDescription", "In order to understand the symbols of the tree better, here's a little legend:");
$template->assign("langTXTHOME_legendPoint1", "This folder contains errors were found by TypeChef");
$template->assign("langTXTHOME_legendPoint2", "This folder contains no errors were found by TypeChef");
$template->assign("langTXTHOME_legendPoint3", "This C-File was excluded from analysis");
$template->assign("langTXTHOME_legendPoint4", "The tested C-File has errors");
$template->assign("langTXTHOME_legendPoint5", "The tested C-File hasn't errors");
?>