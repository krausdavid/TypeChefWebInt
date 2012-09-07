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
 * ./run/site/permalink.php
 *
 * This file will be used for permalinks
 */

$p = $_GET['p'];
$p_arr = explode("/", $_GET['p']);

if($p!=""&&count($p_arr)>=2){
	$project = $p_arr[0];
	$path = "";
	for($i=1;$i<count($p_arr);$i++){
		$path.=$p_arr[$i]."/";
	}
	$path = substr($path,0,-1);
	header('Location: '.$WEBSITE_DEFAULT_URI.'/project?choice=view&files='.$path.'&project='.$project);
}else{
	header('Location: '.$WEBSITE_DEFAULT_URI.'/');
}
?>