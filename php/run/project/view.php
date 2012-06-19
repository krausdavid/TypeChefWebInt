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
//$string = tools::readXMLFile($PROJECT_PATH.$_GET['files'].".c.xml");
$string = tools::readXMLFile("/app/home/eifx/samle.xml");
$xml = simplexml_load_string($string);

$i=0;
while(true){
	if($xml->parsererror[$i]->featurestr!=""){
		$parsererror[$i]['featurestr'] = $xml->parsererror[$i]->featurestr;
		$parsererror[$i]['msg'] = $xml->parsererror[$i]->msg;
		$parsererror[$i]['file'] = $xml->parsererror[$i]->position->file;
		$parsererror[$i]['line'] = $xml->parsererror[$i]->position->line;
		$parsererror[$i]['col'] = $xml->parsererror[$i]->position->col;
		$parsererror[$i]['id'] = $i;
	}else{
		break;
	}
	$i++;
}

$i=0;
while(true){
	if($xml->typeerror[$i]->featurestr!=""){
		$typeerror[$i]['featurestr'] = $xml->typeerror[$i]->featurestr;
		$typeerror[$i]['severity'] = $xml->typeerror[$i]->severity;
		$typeerror[$i]['msg'] = $xml->typeerror[$i]->msg;
		$typeerror[$i]['file'] = $xml->typeerror[$i]->position->file;
		$typeerror[$i]['line'] = $xml->typeerror[$i]->position->line;
		$typeerror[$i]['col'] = $xml->typeerror[$i]->position->col;
		$parsererror[$i]['id'] = $i;
	}else{
		break;
	}
	$i++;
}

$template->assign("parsererror", $parsererror);
$template->assign("parsererrorCount", count($parsererror));
$template->assign("typeerror", $typeerror);
$template->assign("typeerrorCount", count($typeerror));

$template->assign("title", "Projekt '".$_GET['project']."' Dateien: ".$_GET['files'].".*");
$template->assign("template", "./project/view.tpl"); 
?>