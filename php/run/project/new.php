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
if($_REQUEST['cmd_send']){
	if($_POST['txt_name']=="" || $_POST['txt_nickname']=="" || $_POST['txt_version']=="" || $_POST['txt_path']==""){
		$template->assign("error_emptyFields",true);
	}else{
		exec("java -jar ../java/PHP_Tools.jar FINDPROJECTNAME ".GLOBAL_SETTINGS." ".$_POST['txt_nickname'],$project_name_new);

		if(count($project_name_new)==0){
			$template->assign("error_nicknameContainsBadCharacter",true);
			$template->assign("project_nickname_new",$_POST['txt_nickname']);
			$template->assign("project_name_new",$_POST['txt_name']);
			$template->assign("project_version_new",$_POST['txt_version']);
			$template->assign("project_path_new",$_POST['txt_path']);
		}else{
			if($project_name_new[0]!=$_POST['txt_nickname']){
				$template->assign("error_nicknameAlreadySet",true);
				$template->assign("project_nickname_new",$project_name_new[0]);
				$template->assign("project_name_new",$_POST['txt_name']);
				$template->assign("project_version_new",$_POST['txt_version']);
				$template->assign("project_path_new",$_POST['txt_path']);
			}else{
				$shell_execute = nl2br(shell_exec("java -jar ../java/Web_ProjectInitializator.jar ".$_POST['txt_path']." ".$project_name_new[0]." ".$_POST['txt_name']." ".$_POST['txt_version']." ".$session->get("username")." ".GLOBAL_SETTINGS));
				if($shell_execute!=""){
					$shell_execute = $shell_execute."<br/>".nl2br(shell_exec("java -jar ../java/Web_TreeViewInitializator.jar ".$project_name_new[0]." ".GLOBAL_SETTINGS));
				}
				$template->assign("java_output", $shell_execute);
			}
		}
	}
}
 
$template->assign("title", "Neues Projekt anlegen");
$template->assign("template", "./project/new.tpl"); 
?>