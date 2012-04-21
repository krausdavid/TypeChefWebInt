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

//$_GET['project']
$pathArr = explode("/",$_GET['files']);
$pathStr = "";
$i=0;
for($i=0;$i<count($pathArr)-1;$i++){
	$pathStr = $pathStr."/".$pathArr[$i];
}
$arr = tools::get_all_files($PROJECT_PATH.$pathStr,$pathArr[count($pathArr)-1]);

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
	
	//$output_file = str_replace("<","&lt;",$output_file);
	//$output_file = str_replace(">","&gt;",$output_file);

	//Syntax Higlightning
	if($fileEXT==".c"){
		$geshi = new GeSHi($output_file, 'c');
		$output_file = $geshi->parse_code();
	}
	
	$output_file = str_replace("\t"," ",$output_file);
	$output_file_arr = explode("\n",$output_file);
	
	
	for($i=0;$i<count($output_file_arr);$i++){
-		$spaces_display ="";
		for($j=0;$j<(strlen(count($output_file_arr))-strlen($i+1));$j++){
			$spaces_display.=" ";
		}
-		$spaces_wrap ="";
		for($j=0;$j<(strlen(count($output_file_arr)));$j++){
			$spaces_wrap.=" ";
		}
		
		//$out[$i]['line'] = wordwrap($output_file_arr[$i],100,"<br/>".$spaces_wrap." | ",true);
		$out[$i]['line'] = $output_file_arr[$i];
		$out[$i]['nr'] = ($i+1).$spaces_display." | ";
	}
	
	$template->assign("file_output", $out);
}

$template->assign("title", "Projekt '".$_GET['project']."' Dateien: ".$_GET['files'].".*");
$template->assign("template", "./project/main.tpl"); 
?>