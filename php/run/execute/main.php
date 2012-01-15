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
	//TODO Projekt dynamisch machen 
	echo "Anfrage wird bearbeitet...<br>";
	echo shell_exec("java -jar ../java/web_WriteFileList/Web_WriteFileList.jar busybox ".$_GET['chkStr']." /app/home/eifx/public_html/TypeChefWebInt/projects/");
	
	//echo shell_exec("../scripts/useJCPPFileChecker.sh busybox.lst /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 busybox.flags");
	echo shell_exec("/app/archive/kos/share/TypeChef/busybox/analyzeBusybox.sh");
	echo shell_exec("java -jar ../java/web_ProjectInitializator/Web_ProjectInitializator.jar /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 busybox /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
	//echo shell_exec("java -jar ../java/web_ProjectInitializator/Web_ProjectInitializator.jar /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 busybox /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
	echo "DONE!!!";
	
	$template->assign("title", "Skriptauswertung");
	$template->assign("template", "./execute/main.tpl"); 
?>