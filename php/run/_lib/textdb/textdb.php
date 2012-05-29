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
	var $dbc;			//Database in a string
	var $dbpath;		//Datebase-Path
	var $arr_all;		//Database in an array
	var $arr_header;	//Database-Header
	var $actual_ID;		//Actual ID for Auto-Increment
	var $LINE_ENDING;	//Line-ending in a text-file
	
	//Get the current line ending
	private function getLineEnding(){
		if(count(explode("\r\n",$this->dbc))>1){
			$this->LINE_ENDING = "\r\n";
		}
		if(count(explode("\n",$this->dbc))>1){
			$this->LINE_ENDING = "\n";
		}
		if(count(explode("\r",$this->dbc))>1){
			$this->LINE_ENDING = "\r";
		}
		if($this->LINE_ENDING==""){
			$this->LINE_ENDING = "\n";
		}
	}
	
	//Gets the actual ID for auto increment
	private function getActualID(){
		$handle = $this->openFile($this->dbpath.".settings","r");
		while(!feof($handle)){
			$var=explode("=",fgets($handle));
			if(count($var)>0){
				if($var[0]=="AUTO_INCREMENT"){
					$this->actual_ID = $var[1];
				}
			}
		}
		$this->closeFile($handle,$this->dbpath.".settings");
	}

	//Sets the actual ID for auto increment
	private function setActualID(){
		unlink($this->dbpath.".settings");
		$handle = $this->openFile($this->dbpath.".settings","w");
		fputs($handle,"AUTO_INCREMENT=".$this->actual_ID);
		$this->closeFile($handle,$this->dbpath.".settings");
	}
	
	//Open a file. If it is not possible ('cause a lock-file exist)
	//the script will try it 3 times with an delay of an second
	private function openFile($filepath,$type){
		$counter=0;
		for($i=0;$counter<3;$i++){
			if(!file_exists($filepath.".lock")){
				$handleLock = fopen($filepath.".lock","w");
				$handle = fopen($filepath,$type);
				return $handle;
			}
			sleep(1);
			$counter++;
		}
		return false;
	}
	
	//Close a file and deletes the lock-file
	private function closeFile($handle,$filepath){
		unlink($filepath.".lock");
		fclose($handle);
	}
	
	//Get the ID from an given DB-Field
	private function getID($searchFieldName){
		$fieldID=-1;
		for($i=0;$i<count($this->arr_header);$i++){
			if($searchFieldName==$this->arr_header[$i]){
				$fieldID=$i;
			}
		}
		return $fieldID;
	}

	//Connect the db with the local text-variable
	//Implements some needed variables
	function connect($filepath){
		$var="";
		$handle = $this->openFile($filepath,"r");
		while(!feof($handle)){
			$var.=fgets($handle);
		}
		$this->closeFile($handle,$filepath);
		
		$this->dbc = $var;
		$this->getLineEnding();
		$this->dbpath = $filepath;
		$this->arr_all = explode($this->LINE_ENDING,$var);
		if(count($this->arr_all)>0){
			$this->arr_header = explode(";",$this->arr_all[0]);
		}else{
			return false;
		}
		$this->getActualID();
	}
	
	//Close and save the database
	function close(){
		unlink($this->dbpath);
		$handle = $this->openFile($this->dbpath,"w");
		fputs($handle,$this->dbc);
		$this->closeFile($handle,$this->dbpath);
		$this->setActualID();
	}

	//Returns an array with selected fields
	function select_all($fieldname,$fieldval){
		if(count($this->arr_header)>0){
			$fieldID=$this->getID($fieldname);
			
			if($fieldID==-1){
				return false;
			}
			
			$arr_counter=0;
			for($i=1;$i<count($this->arr_all);$i++){
				$arr_entry = explode(";",$this->arr_all[$i]);
				if($arr_entry[$fieldID]==$fieldval){
					for($j=0;$j<count($arr_entry);$j++){
						$output[$arr_counter][$this->arr_header[$j]] = $arr_entry[$j];
					}
					$arr_counter++;
				}
			}
			return $output;
		}else{
			return false;
		}
	}
	
	//Returns a single value
	function select_once($fieldname,$fieldval,$queryfieldname){
		$arr = $this->select_all($fieldname,$fieldval);
		if(count($arr)>0 && $arr!=false){
			return $arr[0][$queryfieldname];
		}else{
			return false;
		}
	}
	
	//Insert an entry into the database
	function insert($arr_insert){
		$id=-1;
		for($i=0;$i<count($this->arr_header);$i++){
			if($this->arr_header[$i]=="id"){
				$id=$i;
			}
		}
		
		if($id==-1){
			return false;
		}
		
		if(count($arr_insert)!=count($this->arr_header)){
			return false;
		}
		
		$insert_str="";
		
		for($i=0;$i<count($this->arr_header);$i++){
			if($i==$id){
				$insert_str.=$this->actual_ID.";";
				$this->actual_ID++;
			}else{
				$insert_str.=$arr_insert[$i].";";
			}
		}
		if(substr($insert_str,-strlen($this->LINE_ENDING))==$this->LINE_ENDING){
			$insert_str = substr($insert_str,0,-1-strlen($this->LINE_ENDING));
		}
		$this->dbc = $this->dbc.$this->LINE_ENDING.$insert_str;
	}
	
	//Deletes an entry in the database
	function delete($fieldname,$fieldval){
		if(count($this->arr_header)>0){
			$fieldID=$this->getID($fieldname);
			
			if($fieldID==-1){
				return false;
			}
			
			$new_db=$this->arr_all[0].$this->LINE_ENDING;
			for($i=1;$i<count($this->arr_all);$i++){
				$arr_entry = explode(";",$this->arr_all[$i]);
				if($arr_entry[$fieldID]!=$fieldval){
					$new_db .= $this->arr_all[$i].$this->LINE_ENDING;
				}
			}
			$new_db = substr($new_db,0,-1);
			
			$this->dbc = $new_db;
		}else{
			return false;
		}
	}
	
	//Updates one or many entries
	function update($updatefieldname,$updatefieldval,$searchfieldname,$searchfieldval){
		if(count($this->arr_header)>0){
			$fieldID=$this->getID($searchfieldname);
			
			if($fieldID==-1){
				return false;
			}
			
			for($i=1;$i<count($this->arr_all);$i++){
				$arr_entry = explode(";",$this->arr_all[$i]);
				if($arr_entry[$fieldID]==$searchfieldval){
					$fieldUpdateID=$this->getID($updatefieldname);
					
					if($fieldUpdateID==-1){
						return false;
					}
					
					$arr_entry[$fieldUpdateID]=$updatefieldval;
					$arr_entry_str = "";
					
					for($j=0;$j<count($arr_entry);$j++){
						$arr_entry_str .= $arr_entry[$j].";";
					}
					$arr_entry_str = substr($arr_entry_str,0,-1);
					
					$this->arr_all[$i] = $arr_entry_str;
				}
			}
			$this->dbc = "";
			for($i=0;$i<count($this->arr_all);$i++){
				if(substr($this->arr_all[$i],-strlen($this->LINE_ENDING))!=$this->LINE_ENDING){
					$this->dbc .= $this->arr_all[$i].$this->LINE_ENDING;
				}else{
					$this->dbc .= $this->arr_all[$i];
				}
			}
			$this->dbc = substr($this->dbc,0,-strlen($this->LINE_ENDING));
		}else{
			return false;
		}
	}
	
	//Count the given entries
	function count($fieldname,$fieldval){
		if(count($this->arr_header)>0){
			$fieldID=$this->getID($fieldname);
			
			if($fieldID==-1){
				return false;
			}
			
			$counter=0;
			for($i=1;$i<count($this->arr_all);$i++){
				$arr_entry = explode(";",$this->arr_all[$i]);
				if($arr_entry[$fieldID]==$fieldval){
					$counter++;
				}
			}
			
			return $counter;
		}else{
			return false;
		}
	}
}
?>