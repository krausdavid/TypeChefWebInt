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
 * ./run/project/view.php
 *
 * This file shows single c-files from a given project
 */

$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$_GET['project'].".project.xml");
$xml = simplexml_load_string($string);

for($i=0;$i<$xml->errors[0]->file->count();$i++){
	if($xml->errors[0]->file[$i]->path==$_GET['files']){
		for($j=0;$j<$xml->errors[0]->file[$i]->errorlist[0]->parsererror->count();$j++){
			$parsererror[$j]['featurestr'] = $xml->errors[0]->file[$i]->errorlist[0]->parsererror[$j]->featurestr;
			$parsererror[$j]['msg'] = $xml->errors[0]->file[$i]->errorlist[0]->parsererror[$j]->msg;
			$parsererror[$j]['line'] = $xml->errors[0]->file[$i]->errorlist[0]->parsererror[$j]->position->line;
			$parsererror[$j]['col'] = $xml->errors[0]->file[$i]->errorlist[0]->parsererror[$j]->position->col;
			$parsererror[$j]['id'] = $j+1;
		}
		for($j=0;$j<$xml->errors[0]->file[$i]->errorlist[0]->typererror->count();$j++){
			$typeerror[$j]['featurestr'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->featurestr;
			$typeerror[$j]['severity'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->severity;
			$typeerror[$j]['msg'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->msg;
			$typeerror[$j]['fromline'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->position[0]->line;
			$typeerror[$j]['fromcol'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->position[0]->col;
			$typeerror[$j]['toline'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->position[1]->line;
			$typeerror[$j]['tocol'] = $xml->errors[0]->file[$i]->errorlist[0]->typeerror[$j]->position[1]->col;
			$typeerror[$j]['id'] = $j+1;
		}
		if($xml->errors[0]->file[$i]->excluded=="true"){
			$template->assign("excluded", true);
		}
		if($xml->errors[0]->file[$i]->compileerror=="true"){
			$template->assign("compileerror", true);
		}
	}
}

$template->assign("parsererror", $parsererror);
$template->assign("parsererrorCount", count($parsererror));
$template->assign("typeerror", $typeerror);
$template->assign("typeerrorCount", count($typeerror));
$template->assign("errorCount", count($typeerror)+count($parsererror));

$template->assign("title", "Projekt '".$_GET['project']."' Dateien: ".$_GET['files'].".*");
$template->assign("template", "./project/view.tpl"); 
?>