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
	var $dbpath;

	//Connect the db with the local text-variable
	function connect($filepath){
		$var="";
		$handle = fopen($filepath,"r+");
		while(!feof($handle)){
			$var.=fgets($handle)."\r\n";
		}
		fclose($handle);
		$this->dbc = $var;
		$this->dbpath = $filepath;
	}
	
	//Close and save the database
	function close(){
		unlink($this->dbpath);
		$handle = fopen($this->dbpath,"w+");
		fputs($handle,$this->dbc);
		fclose($handle);
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
	
	//Insert an entry into the database
	function insert($arr_insert){
		$arr_all = explode("\r\n",$this->dbc);
		if(count($arr_all)>0){
			$id=-1;
			if(count($arr_all)>1){
				$id_arr = explode(";",$arr_all[count($arr_all)-1]);
				$id = $id_arr[0];
			}else{
				$id=0;
			}
			
			$arr_header = explode(";",$arr_all[0]);
			if(count($arr_insert)!=count($arr_header)){
				return false;
			}
			
			$insert_str="";
			
			for($i=0;$i<count($arr_header);$i++){
				$insert_str.=$arr_insert[$i].";";
			}
			$insert_str = substr($insert_str,0,-1);
			$this->dbc = ($this->dbc)."\r\n".$insert_str;
		}else{
			return false;
		}
	}
	
	//Deletes an entry in the database
	function delete($fieldname,$fieldval){
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
				
				$new_dbc=$arr_all[0]."\r\n";
				for($i=1;$i<count($arr_all);$i++){
					$arr_entry = explode(";",$arr_all[$i]);
					if($arr_entry[$fieldID]!=$fieldval){
						$new_db .= $arr_all[$i]."\r\n";
					}
				}
				$new_db = substr($new_db,0,-2);
				
				$this->dbc = $new_db;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	//Updates one or many entries
	function update($updatefieldname,$updatefieldval,$searchfieldname,$searchfieldval){
	$arr_all = explode("\r\n",$this->dbc);
		if(count($arr_all)>0){
			$arr_header = explode(";",$arr_all[0]);
			if(count($arr_header)>0){
				$fieldID=-1;
				for($i=0;$i<count($arr_header);$i++){
					if($searchfieldname==$arr_header[$i]){
						$fieldID=$i;
					}
				}
				
				if($fieldID==-1){
					return false;
				}
				
				$arr_all_str="";

				for($i=1;$i<count($arr_all);$i++){
					$arr_entry = explode(";",$arr_all[$i]);
					if($arr_entry[$fieldID]==$searchfieldval){
						$fieldUpdateID=-1;
						
						for($j=0;$j<count($arr_header);$j++){
							if($updatefieldname==$arr_header[$j]){
								$fieldUpdateID=$j;
							}
						}
						
						if($fieldUpdateID==-1){
							return false;
						}
						
						$arr_entry[$fieldUpdateId]=$updatefieldval;
						$arr_entry_str = "";
						
						for($j=0;$j<count($arr_entry);$j++){
							$arr_entry_str .= $arr_entry[$j].";";
						}
						$arr_entry_str = substr($arr_entry_str,0,-1);
						
						$arr_all_str .= $arr_entry_str."/r/n";
					}
				}

				$this->dbc = $arr_all[0].$arr_all_str;
				
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
	
	function count($fieldname,$fieldval){
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
				
				$counter=0;
				
				for($i=1;$i<count($arr_all);$i++){
					$arr_entry = explode(";",$arr_all[$i]);
					if($arr_entry[$fieldID]==$fieldval){
						$counter++;
					}
				}
				
				return $counter;
			}else{
				return false;
			}
		}else{
			return false;
		}
	}
}
?>