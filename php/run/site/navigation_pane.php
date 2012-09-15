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
 * ./run/site/navigation_pane.php
 *
 * This whole methods are needed for the navigation-pane
 * in the left upper corner
 */

//Check, if user has switched between "Show Errors" and "Show no Errors"
if((isset($_POST['chk_showOnlyErrors']) && $_POST['chk_showOnlyErrors']=="checked") && (isset($_POST['showOnlyErrors_val']) && $_POST['showOnlyErrors_val']=="val")){
	$session->set("showOnlyErrors",true);
}
if(!isset($_POST['chk_showOnlyErrors']) && (isset($_POST['showOnlyErrors_val']) && $_POST['showOnlyErrors_val']=="val")){
	$session->set("showOnlyErrors",false);
}
$template->assign("showOnlyErrors", $session->get("showOnlyErrors"));

//Gets the current project-type, needs an actual session-object
function getActualProjectType($session,$projectMan){
	return $projectMan->getProjectTypeFromGivenProject($session->get('current_project'));
}

//Check if the user change a project
if(isset($_POST['project']) && substr($_POST['project'],0,1)=="_"){
	$session->set('current_project',substr($_POST['project'],1));
}
if(isset($_POST['deltas']) && substr($_POST['deltas'],0,1)=="_"){
	$session->set('current_project',substr($_POST['deltas'],1));
}

//Read all projects from the project-path and store the information
//into the project-manager
$handle = opendir($WEBSITE_PROJECT_PATH);
$i=0;
while($file = readdir($handle)){
	if(strpos($file,FILENAMEENDING_PROJECT)!==false || strpos($file,FILENAMEENDING_DELTA)!==false || strpos($file,FILENAMEENDING_COMPARE)!==false){
		$file_name = "";
		if(strpos($file,FILENAMEENDING_PROJECT)!==false){
			$file_name = substr($file,0,-strlen(FILENAMEENDING_PROJECT));
		}elseif(strpos($file,FILENAMEENDING_DELTA)!==false){
			$file_name = substr($file,0,-strlen(FILENAMEENDING_DELTA));
		}else{
			$file_name = substr($file,0,-strlen(FILENAMEENDING_COMPARE));
		}
	
		$file_list[$i]['name'] = $file_name;
		$file_list[$i]['id'] = $i;
		$file_list[$i]['selected'] = false;
		if($session->get('current_project')==$file_name){
			$file_list[$i]['selected'] = true;
		}
		$i++;
	}
}
closedir($handle);
$projectMan->addFilesArr($file_list);

//Check if a delta is selected
$template->assign("is_a_delta_selected", $projectMan->isGivenTypeSelected(TYPE_DELTA));

//Check if the current project is deleted
if(!$projectMan->isExistAGivenProject($session->get('current_project'))){
	$session->set('current_project', $projectMan->getFirstProjectFromAGivenType(TYPE_PROJECT));
	$projectMan->selectAProjectWithGivenProjectName($session->get('current_project'));
}

//Check if the given project from the database is exist
if(!$projectMan->isExistAGivenProject($session->get('initial_project'))){
	$new_project = $projectMan->getFirstProjectFromAGivenType(TYPE_PROJECT);
	$template->assign("error_projectDeleted", true);
	$template->assign("error_projectDeleted_project_old", $session->get('initial_project'));
	$template->assign("error_projectDeleted_project_new", $new_project);
	$session->set('initial_project', $new_project);
	$session->set('current_project',$new_project);
	if($session->get("id")!=0 && $session->get("rights")){ //Only active, if an user has logged in
		$textdb_login->update("initial_project",$new_project,"id",$session->get('id'));
	}
}

//Generates the lists for output
$projectMan->projectList_generate();
$projectMan->deltaList_generate();
$projectMan->compareList_generate();

//Prepares the option-boxes for correct display the entries
$orign_project_name = $projectMan->getProjectThatBelongsToAGivenDelta($session->get('current_project'));
$template->assign("project_name_origin",$orign_project_name);
if(getActualProjectType($session,$projectMan)==TYPE_DELTA){
	$projectMan->projectList_selectAnProject($orign_project_name);
}elseif(getActualProjectType($session,$projectMan)==TYPE_COMPARE){
	$projectMan->compareList_selectCorrectEntriesInProjectListAndDeltaList($session->get('current_project'));
}

//Get the correct delta-list
$delt_list = $projectMan->deltaList_getAllDeltasToAGivenProject($session->get('current_project'));
$template->assign("projects_deltas",$delt_list);
$template->assign("projects_deltas_compare",$delt_list);

//Get the project-list
$template->assign("projects_list", $projectMan->projectList_getProjectList());

//Checks whether projects are available 
if($projectMan->projectList_countProjectList()==0){
	$template->assign("project_name", "emptytree/empty");
	$template->assign("login", true);
}else{
	//Read the current project-settings-file
	$PROJECT_PATH = "";
	$template->assign("project_name", $session->get('current_project'));
	$template->assign("login", true);
	
	if(getActualProjectType($session,$projectMan)==TYPE_PROJECT){
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$session->get('current_project').FILENAMEENDING_PROJECT);
	}elseif(getActualProjectType($session,$projectMan)==TYPE_DELTA){
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$session->get('current_project').FILENAMEENDING_DELTA);
	}elseif(getActualProjectType($session,$projectMan)==TYPE_COMPARE){
		$string = tools::readXMLFile($WEBSITE_PROJECT_PATH."/".$session->get('current_project').FILENAMEENDING_COMPARE);
	}
	$xml = simplexml_load_string($string);
	
	$PROJECT_PATH = $xml->header->project->path."/";
}

//Checks if the user want to delete a project
if(isset($_REQUEST['cmd_delete_project']) && $_REQUEST['cmd_delete_project']){
	exec("java -jar ../java/Web_ProjectDelete.jar ".$session->get('current_project')." ".GLOBAL_SETTINGS);
	header('Location: '.$WEBSITE_DEFAULT_URI.'/');
}

//Checks if the user want to compare a project
if(isset($_REQUEST['cmd_projects_deltas_compare'])){
	$comp_pro_name = $_POST['deltas_compare'];
	
	//Checks if the compare-file exist already
	$project_name_compare = $session->get('current_project')."__".$comp_pro_name;
	$filename_compare = $WEBSITE_PROJECT_PATH."/".$project_name_compare.FILENAMEENDING_COMPARE;

	if(!file_exists($filename_compare)){
		shell_exec("java -jar ".$WEBSITE_DIR_PATH."/java/Web_ProjectCompare.jar ".$session->get('current_project')." ".$comp_pro_name." ".$session->get("username")." ".GLOBAL_SETTINGS);
		shell_exec("java -jar ".$WEBSITE_DIR_PATH."/java/Web_TreeViewInitializator.jar ".$project_name_compare." ".GLOBAL_SETTINGS);
	}

	$session->set('current_project',$project_name_compare);
	header('Location: '.$WEBSITE_DEFAULT_URI.'/?mainproject='.$session->get('current_project').'&compareproject='.$comp_pro_name);
}
?>