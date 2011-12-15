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
	
	function login_exists()
	{
		global $session;
		return $session->get("login");
	}

	function read_file($file,$break)
	{
		$handle = fopen($file, "r");
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
	
	function read_uploaded_file($ufile)
	{
		$temp = tempnam(WEBSITE_TEMP_DIRECTORY, $ufile['name']);
		move_uploaded_file($ufile['tmp_name'], $temp);
		chmod($temp, 0777);
		$handle = fopen($temp, "r");
		$fcontent = fread($handle, filesize($temp));
		fclose($handle);
		unlink($temp);
		return $fcontent;
	}
	
	function get_file_extension($filename)
	{
		$extension = "";
		$chars = str_split($filename);
		for ($i = strlen($filename) - 1; $i >= 0; $i--) {
			if ($filename[$i] != ".") {
				$extension = $chars[$i].$extension;
			} else {
				break;
			}
		}
		return strtolower($extension);
	}
	
	function strip_html_special_chars($str)
	{
		$str = str_replace("&", "", $str);
		$str = str_replace("\"", "", $str);
		$str = str_replace("'", "", $str);
		$str = str_replace("<", "", $str);
		$str = str_replace(">", "", $str);
		return $str;
	}
	
	function is_valid_user_name($user_name)
	{
		$regex = '[a-zA-Z0-9][a-zA-Z0-9_.-]*';
		$common_valid = preg_match("/^$regex$/", $user_name);
		
		return $common_valid;
	}
	
	function is_valid_email_address($email_address)
	{
		$nonascii = "\x80-\xff";
		$nqtext = "[^\\\\$nonascii\015\012\"]";
		$qchar = "\\\\[^$nonascii]";
		$protocol = '(?:mailto:)';
		$normuser = '[a-zA-Z0-9][a-zA-Z0-9_.-]*';
		$quotedstring = "\"(?:$nqtext|$qchar)+\"";
		$user_part = "(?:$normuser|$quotedstring)";
		$dom_mainpart = '[a-zA-Z0-9][a-zA-Z0-9._-]*\\.';
		$dom_subpart = '(?:[a-zA-Z0-9][a-zA-Z0-9._-]*\\.)*';
		$dom_tldpart = '[a-zA-Z]{2,5}';
		$domain_part = "$dom_subpart$dom_mainpart$dom_tldpart";
		$regex = "$protocol?$user_part\@$domain_part";
		return preg_match("/^$regex$/", $email_address);
	}

}

?>
