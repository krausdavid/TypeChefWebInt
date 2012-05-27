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
if($_REQUEST['cmd_send']){
	echo "java -jar ../java/PHP_Tools.jar FINDPROJECTNAME /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml ".$_POST['txt_nickname']."<br><br>";
	echo shell_exec("java -jar ../java/PHP_Tools.jar FINDPROJECTNAME /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml ".$_POST['txt_nickname']);
}
 
$template->assign("title", "Neues Projekt anlegen");
$template->assign("template", "./project/new.tpl"); 
?>