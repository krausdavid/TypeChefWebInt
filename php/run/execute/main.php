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
	echo "Anfrage wird bearbeitet...";
	shell_exec("java -jar ../java/web_WriteFileList/Web_WriteFileList.jar busybox ".$_GET['chkStr']);
	//shell_exec("../scripts/useJCPPFileChecker-out.sh busybox.lst /app/home/krausdavid/TypeChefWebInt/TypeChefWebInt/projects/busybox-1.18.5 busybox.flags");
	echo "DONE!!!";
	
	$template->assign("title", "Skriptauswertung");
	$template->assign("template", "./execute/main.tpl"); 
?>