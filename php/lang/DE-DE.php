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
 
$template->assign("langERR_403Forbidden", "KEIN ZUGRIFF");
$template->assign("langERR_403NotFound", "SEITE NICHT GEFUNDEN");
$template->assign("langERR_501NotImplemented", "NICHT ENTWICKELT");
$template->assign("langERRTXT_403ErrorMessage", "Entschuldigung, aber auf diese Seite haben Sie keinen Zugriff<br><br>Sie besitzen nicht die nötigen Rechte um den Inhalt dieser Seite zu betrachten.");
$template->assign("langERRTXT_404ErrorMessage", "Entschuldigung, aber die von Ihnen gewählte Seite ist nicht verfügbar.<br><br>Vermutlich ist ein Fehler im aufgerufenen Link oder der Bereich ist temporär nicht verfügbar.");
$template->assign("langERRTXT_501ErrorMessage", "Entschuldigung, aber diese Seite ist noch nicht fertig entwickelt.<br><br>Es wird versucht, diesen Bereich so schnell wie möglich fertig zu stellen.");
$template->assign("langERRTXT_wrongLogin", "Login fehlgeschlagen! Benutzername / Passwort stimmen nicht überein.");

$template->assign("langINF_information", "Hinweis");

$template->assign("langINFTXT_deletedProject_PART1", "Ihr aktuelles Projekt wurde entfernt. Sie wurden nun automatisch von");
$template->assign("langINFTXT_deletedProject_PART2", "nach");
$template->assign("langINFTXT_deletedProject_PART3", "weitergeleitet. Dieses Projekt wurde als Favorit gekennzeichnet.");

$template->assign("langTXT_actualProject", "Aktuelles Projekt");
$template->assign("langTXT_compareTwoProjects", "Zwei Projekte vergleichen");
$template->assign("langTXT_hello", "Hallo");
$template->assign("langTXT_homepage", "Startseite");
$template->assign("langTXT_login", "Login");
$template->assign("langTXT_logout", "Logout");
$template->assign("langTXT_name", "Name");
$template->assign("langTXT_newProject", "Neues Projekt...");
$template->assign("langTXT_noProjectsExist", "Keine Projekte vorhanden");
$template->assign("langTXT_options", "Optionen");
$template->assign("langTXT_password", "Passwort");
$template->assign("langTXT_projects", "Projekte");
$template->assign("langTXT_pleaseActivateJavaScript", "Bitte aktivieren Sie JavaScript!");
$template->assign("langTXT_settings", "Einstellungen");

$template->assign("langTXTHOME_topic", "Hallo und Willkommen beim TypeChefWebInt");
$template->assign("langTXTHOME_descripton", "Links sehen Sie im Baum ein gerade geladenes Projekt. Sie können sich durch den Baum navigieren und eine Dateiengruppe Ihrer Wahl sich anzeigen lassen. Sobald Sie sich für eine Dateiengruppe entschieden haben, können Sie sich für eine bestimmte Datei entscheiden.");
$template->assign("langTXTHOME_legendDescription", "Um die Symbole des Baumes besser verstehen zu können, hier eine kleine Legende:");
$template->assign("langTXTHOME_legendPoint1", "In diesem Ordner sind Fehler von TypeChef gefunden worden");
$template->assign("langTXTHOME_legendPoint2", "In diesem Ordner sind keine Fehler von TypeChef gefunden worden");
$template->assign("langTXTHOME_legendPoint3", "TypeChef hat diese C-Datei nicht korrekt geprüft oder sie wurde ausgeschlossen");
$template->assign("langTXTHOME_legendPoint4", "Die geprüfte C-Datei weist Fehler auf");
$template->assign("langTXTHOME_legendPoint5", "Die C-Datei enthält keine Fehler");

?>