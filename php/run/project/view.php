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
	//Get the file extension
	$fileEXTarr = explode(".",$_GET['choosen_file']);
	$fileEXT = "";
	
	for($i=1;$i<count($fileEXTarr);$i++){
		$fileEXT .= ".".$fileEXTarr[$i];
	}
	
	//Replace < and > Tags. HTML display this characters wrong. This is only for
	//not syntaxable files
	$output_file = tools::read_file($PROJECT_PATH.$_GET['files'].$fileEXT,false);
	
	$isSyntaxable = false;
	if($fileEXT==".c" || $fileEXT==".c.interface" || $fileEXT==".interface" || $fileEXT==".pi" || $fileEXT==".xml"){
		$isSyntaxable = true;
	}
	
	if(!$isSyntaxable){
		$output_file = str_replace("<","&lt;",$output_file);
		$output_file = str_replace(">","&gt;",$output_file);
	}
	
	$output_file = str_replace("\t"," ",$output_file);
	$output_file = str_replace("\r","",$output_file);
	$output_file_arr = explode("\n",$output_file);
	
	for($i=0;$i<count($output_file_arr);$i++){
		//Wordwrap if the given text is not syntaxable
		if(!$isSyntaxable){
			$spaces_wrap ="";
			for($j=0;$j<(strlen(count($output_file_arr)));$j++){
				$spaces_wrap.=" ";
			}
			$out[$i]['line'] = wordwrap($output_file_arr[$i],100,"<br/>".$spaces_wrap." | ",true);
		}else{
			$out[$i]['line'] = $output_file_arr[$i];
		}
		
		$out[$i]['nr'] = ($i+1).$spaces_display." | ";
	}
	
	$template->assign("file_output", $out);
}

$template->assign("title", "Projekt '".$_GET['project']."' Dateien: ".$_GET['files'].".*");
$template->assign("template", "./project/view.tpl"); 
?>