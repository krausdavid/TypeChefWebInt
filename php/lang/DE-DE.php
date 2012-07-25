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
require("./lang/EN-US.php");
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

$template->assign("langINFTXT_emptyFields", "Mindestens 1 Feld wurde leer gelassen.");
$template->assign("langINFTXT_nicknameAlreadySet", "Der Projekt-Nickname ist bereits vergeben! Eine andere Nickname-Möglichkeit wurde bereits in das Feld \"Nickname\" eingetragen.");
$template->assign("langINFTXT_nicknameContainsBadCharacter", "Der gewählte Projekt-Nickname beinhaltet Zeichen, die nicht erlaubt sind. Erlaubt sind Buchstaben, Zahlen, Punkt, Unterstrich und Bindestrich.");

$template->assign("langTXT_actualProject", "Aktuelles Projekt");
$template->assign("langTXT_compareTwoProjects", "Zwei Projekte vergleichen");
$template->assign("langTXT_deleteProject", "Projekt löschen");
$template->assign("langTXT_deltas", "Deltas");
$template->assign("langTXT_evaluation", "Auswertung");
$template->assign("langTXT_hello", "Hallo");
$template->assign("langTXT_homepage", "Startseite");
$template->assign("langTXT_login", "Login");
$template->assign("langTXT_logout", "Logout");
$template->assign("langTXT_mainproject", "Hauptprojekt");
$template->assign("langTXT_name", "Name");
$template->assign("langTXT_nickname", "Nickname");
$template->assign("langTXT_newProject", "Neues Projekt...");
$template->assign("langTXT_newProjectCreate", "Neues Projekt erstellen");
$template->assign("langTXT_noProjectsExist", "Keine Projekte vorhanden");
$template->assign("langTXT_options", "Optionen");
$template->assign("langTXT_password", "Passwort");
$template->assign("langTXT_path", "Pfad");
$template->assign("langTXT_projects", "Projekte");
$template->assign("langTXT_pleaseActivateJavaScript", "Bitte aktivieren Sie JavaScript!");
$template->assign("langTXT_settings", "Einstellungen");
$template->assign("langTXT_version", "Version");

$template->assign("langTXTHOME_topic", "Hallo und Willkommen beim TypeChefWebInt");
$template->assign("langTXTHOME_descripton", "Links sehen Sie im Baum ein gerade geladenes Projekt. Sie können sich durch den Baum navigieren und eine Dateiengruppe Ihrer Wahl sich anzeigen lassen. Sobald Sie sich für eine Dateiengruppe entschieden haben, können Sie sich für eine bestimmte Datei entscheiden.");
$template->assign("langTXTHOME_legendDescription", "Um die Symbole des Baumes besser verstehen zu können, hier eine kleine Legende:");
$template->assign("langTXTHOME_legendPoint1", "In diesem Ordner sind Fehler von TypeChef gefunden worden");
$template->assign("langTXTHOME_legendPoint2", "In diesem Ordner sind keine Fehler von TypeChef gefunden worden");
$template->assign("langTXTHOME_legendPoint3", "Diese C-Datei wurde von der Analyse ausgeschlossen");
$template->assign("langTXTHOME_legendPoint4", "Die geprüfte C-Datei weist Fehler auf");
$template->assign("langTXTHOME_legendPoint5", "Typechef konnte diese C-Datei nicht Parsen: Es trat ein Fehler auf");
$template->assign("langTXTHOME_legendPoint6", "Die C-Datei enthält keine Fehler");

$template->assign("langTXTNEWPROJECT_loadSuccessfull", "Das Projekt wurde erfolgreich geladen.");
$template->assign("langTXTNEWPROJECT_loadError", "Es ist ein Fehler aufgetreten. Vermutlich war einer der eingegebenen Parameter falsch.");
$template->assign("langTXTNEWPROJECT_topic", "Tragen Sie hier die Daten für das neue Projekt ein");

$template->assign("langTXTVIEWPROJECT_error", "Diese C-Datei enthält Fehler.");
$template->assign("langTXTVIEWPROJECT_error_compileerror", "Diese C-Datei hat einen Kompilierungs-Fehler, der durch TypeChef verursacht wurde.");
$template->assign("langTXTVIEWPROJECT_result", "Ergebnisse");
$template->assign("langTXTVIEWPROJECT_noerror", "Diese C-Datei enthält keine Fehler.");
$template->assign("langTXTVIEWPROJECT_noerror_excluded", "Diese C-Datei wurde von der Analyse ausgeschlossen.");

?>