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
 * ./run/execute/main.php
 *
 * This file executes some java-classes
 */
tools::right_exists();

	//TODO Projekt dynamisch machen 
	echo "Anfrage wird bearbeitet...<br><br>";
	echo "Web_WriteFileList wird ausgeführt<br>";
	if($_GET['chkStr']!=""){
		echo shell_exec("java -jar ../java/Web_WriteFileList.jar ".$PROJECT_NAME." ".$_GET['chkStr']." /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
	}else{
		echo shell_exec("java -jar ../java/Web_WriteFileList.jar ".$PROJECT_NAME." EMPTY /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
	}
	
	//echo shell_exec("../scripts/useJCPPFileChecker.sh busybox.lst /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 busybox.flags");
	echo "<br><br>analyzeBusybox.sh wird ausgeführt<br>";
	echo "Shell-Script vorübergehend deaktiviert";
	//echo shell_exec("/app/archive/kos/share/TypeChef/busybox/analyzeBusybox.sh");
	echo "<br><br>Web_ProjectInitializator.jar wird ausgeführt<br>";
	echo shell_exec("java -jar ../java/Web_ProjectInitializator.jar /app/archive/kos/share/TypeChef/busybox/busybox-1.18.5 ".$PROJECT_NAME." BusyBox 1.18.5 EifX /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
	echo "<br><br>Web_TreeViewInitializator.jar wird ausgeführt<br>";
	echo shell_exec("java -jar ../java/Web_TreeViewInitializator.jar ".$PROJECT_NAME." /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
	echo "<br><br>DONE!!!";
	
	$template->assign("title", "Skriptauswertung");
	$template->assign("template", "./execute/main.tpl"); 
?>