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

 
$arr = tools::get_all_files($PROJECT_PATH."/applets","applets");
$template->assign("files", $arr);
$template->assign("project", $_GET['project']);
$template->assign("files_get", $_GET['files']);

if($_GET['choosen_file']!=""){
	$fileEXTarr = explode(".",$_GET['choosen_file']);
	$fileEXT = "";
	
	for($i=1;$i<count($fileEXTarr);$i++){
		$fileEXT .= ".".$fileEXTarr[$i];
	}
	
	//Replace < and > Tags. HTML display this characters wrong
	$output_file = tools::read_file($PROJECT_PATH.$_GET['files'].$fileEXT,false);
	$output_file = str_replace("<","&lt;",$output_file);
	$output_file = str_replace(">","&gt;",$output_file);
	
	$template->assign("filecontent", $output_file);
}

$template->assign("title", "Projekt '".$_GET['project']."' Dateien: ".$_GET['files'].".*");
$template->assign("template", "./project/main.tpl"); 
?>