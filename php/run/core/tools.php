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

class tools
{
	function have_rights(){
		return $_SESSION["rights"];
	}

	function right_exists(){
		if($_SESSION["rights"]==false){
			header("Location: ".$WUD."403_forbidden");
		}
	}
	
	function read_settings($setting){
		$handle = fopen(SETTING_FILE,"r");
		$fcontent = "";
		if($handle){
			while(!feof($handle)){
				$setting_arr = explode("=",fgets($handle));
				if(count($setting_arr)>1){
					if($setting_arr[0] == $setting){
						fclose($handle);
						return $setting_arr[1];
					}
				}
			}
			fclose($handle);
		}
		return "ERR";
	}

  function reload_tree(){
		//return shell_exec("java -jar ../java/web_TreeViewInitializator/web_TreeViewInitializator.jar /app/archive/kos/share/TypeChef/cprojects/busybox/busybox-1.18.5 busybox /app/home/eifx/public_html/TypeChefWebInt/global_settings.xml");
  }
	//This function get a path from a file without file-extension.
	//It returns all files in a array that belongs to the given path
	function get_all_files($path,$file){
		$dir = scandir($path);
		$arr = array();
		foreach($dir as $item) {
			$filename_split = explode(".",$item);
			if(count($filename_split)>0){
				if($filename_split[0]==$file){
					array_push($arr, $item);
				}
			}
		}
		return $arr;
	}

	function read_file($file,$break)
	{
		$handle = fopen($file, "r");
		$fcontent = "";
		if ($handle){
			while(!feof($handle)){
				if($break==true){
					$fcontent = $fcontent."<br>".fgets($handle);
				}else{
					$fcontent = $fcontent.fgets($handle);
				}
			}
			fclose($handle);
		}
		return str_replace("/r", "<br>", $fcontent);
	}
	
	function read_simple_file($file)
	{
		$handle = fopen($file, "r");
		$fcontent = "";
		if ($handle){
			while(!feof($handle)){
				$fcontent = $fcontent.fgets($handle);
			}
			fclose($handle);
		}
		return $fcontent;
	}	
	function readXMLFile($settingXMLPath){
		$var="";
		$handle = fopen($settingXMLPath,"r");
		if($handle){
			while(!feof($handle)){
				$var.=fgets($handle);
			}
		}
		return $var;
	}

}

?>
