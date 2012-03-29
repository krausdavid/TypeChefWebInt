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
class textdb{
	var $dbc;

	//Connect the db with the local text-variable
	function connect($filepath){
		$var="";
		$handle = fopen($filepath,"w+");
		while(!feof($handle)){
			$var.=fgets($handle)."\r\n";
		}
		fclose($handle);
		$this->dbc = $var;
	}

	//Returns an array with selected fields
	function select_all($fieldname,$fieldval){
		$arr_all = explode("\r\n",$this->dbc);
		if(count($arr_all)>0){
			$arr_header = explode(";",$arr_all[0]);
			if(count($arr_header)>0){
				$fieldID=-1;
				for($i=0;$i<count($arr_header);$i++){
					if($fieldname==$arr_header[$i]){
						$fieldID=$i;
					}
				}
				
				if($fieldID==-1){
					return false;
				}
				
				for($i=1;$i<count($arr_all);$i++){
					$arr_entry = explode(";",$arr_all[$i]);
					if($arr_entry[$fieldID]==$fieldval){
						for($j=0;$j<count($arr_entry);$j++){
							$output[$i][$arr_header[$j]] = $arr_entry[$j];
						}
					}
				}
				return $output;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
}
?>