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
 * ./run/core/project_manager.php
 *
 * This class manage all projects in a given project-dir
 */

class project_manager{
	//Main "Database"
	var $filesArr;
	
	//Manually filled with methods
	var $projects_list;
	var $deltas_list;
	var $compares_list;
	
	//Some constants, should be defined by create an object from this class
	var $TYPE_PROJECT;
	var $TYPE_COMPARE;
	var $TYPE_DELTA;
	var $FILENAMEENDING_PROJECT;
	var $FILENAMEENDING_COMPARE;
	var $FILENAMEENDING_DELTA;
	
	/* DESC  : Fill the database
	 * NEEDS : 2D-Array with following structure: arr[INT][STRING]
	 * RETURN: (VOID)
	 */
	function addFilesArr($newFilesArr){
		$this->filesArr = $newFilesArr;
	}
	
	/* DESC  : Get the project-type from a given project-name
	 * NEEDS : A project-name (STRING)
	 * RETURN: A project-type (STRING)
	 */
	function getProjectTypeFromGivenProject($project_name){
		if(strpos($project_name,"__")!==false){
			return $this->TYPE_COMPARE;
		}elseif(strpos($project_name,"_")!==false){
			return $this->TYPE_DELTA;
		}else{
			return $this->TYPE_PROJECT;
		}
	}
	
	/* DESC  : Check if a given project-type is marked as selected
	 * NEEDS : A project-type (TYPE_PROJECT || TYPE_COMPARE || TYPE_DELTA)
	 * RETURN: (BOOLEAN)
	 */
	function isGivenTypeSelected($project_type){
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->getProjectTypeFromGivenProject($this->filesArr[$i]['name'])==$project_type && $this->filesArr[$i]['selected']==true){
				return true;
			}
		}
		return false;
	}

	/* DESC  : Check if a given project-name exist as a project
	 * NEEDS : A project-name (STRING)
	 * RETURN: (BOOLEAN)
	 */
	function isExistAGivenProject($project_name){
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->filesArr[$i]['name']==$project_name){
				return true;
			}
		}
		return false;
	}
	
	/* DESC  : Get the first project from an given type
	 * NEEDS : A project-type (TYPE_PROJECT || TYPE_COMPARE || TYPE_DELTA)
	 * RETURN: A project-name (STRING) if found, otherwise an empty STRING
	 */
	function getFirstProjectFromAGivenType($project_type){
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->getProjectTypeFromGivenProject($this->filesArr[$i]['name'])==$project_type){
				return $this->filesArr[$i]['name'];
			}
		}
		return "";
	}
	
	/* DESC  : Select a project with given project-name
	 * NEEDS : A project-name (STRING)
	 * RETURN: (VOID)
	 */
	function selectAProjectWithGivenProjectName($project_name){
		$project_exist = false;
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->filesArr[$i]['name']==$project_name){
				$this->filesArr[$i]['selected'] = true;
				$project_exist = true;
			}else{
				$this->filesArr[$i]['selected'] = false;
			}
		}
		if(!$project_exist){
			if(count($this->filesArr)>0){
				$this->filesArr[0]['selected'] = true;
			}
		}
	}
	
	/* DESC  : Get the project that belongs to a given delta
	 * NEEDS : A project-name (STRING)
	 * RETURN: A project-name (STRING) if found, otherwise an empty STRING
	 */
	function getProjectThatBelongsToAGivenDelta($project_name){
		$project_arr = explode("_",$project_name);
		if(count($project_arr)>0){
			return $project_arr[0];
		}else{
			return "";
		}
	}
	
// --- Projects-list-functions ---
	
	/* DESC  : Generate the project-list from filesArr
	 * NEEDS : (VOID)
	 * RETURN: (VOID)
	 */
	function projectList_generate(){
		$j=0;
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->getProjectTypeFromGivenProject($this->filesArr[$i]['name'])==$this->TYPE_PROJECT){
				$this->projects_list[$j]['id'] = $this->filesArr[$i]['id'];
				$this->projects_list[$j]['name'] = $this->filesArr[$i]['name'];
				$this->projects_list[$j]['selected'] = $this->filesArr[$i]['selected'];
				$j++;
			}
		}
	}
	
	/* DESC  : Select a project with a given project-name
	 * NEEDS : A project-name (STRING)
	 * RETURN: (VOID)
	 */
	function projectList_selectAnProject($project_name){
		for($i=0;$i<count($this->projects_list);$i++){
			if($this->projects_list[$i]['name']==$project_name){
				$this->projects_list[$i]['selected'] = true;
			}else{
				$this->projects_list[$i]['selected'] = false;
			}
		}
	}
	
	/* DESC  : Get the projects_list-Array
	 * NEEDS : (VOID)
	 * RETURN: projects_list-Array (ARRAY)
	 */
	function projectList_getProjectList(){
		return $this->projects_list;
	}
	
	/* DESC  : Get the count from projects_list
	 * NEEDS : (VOID)
	 * RETURN: The count (INTEGER)
	 */
	function projectList_countProjectList(){
		return count($this->projects_list);
	}

// --- Deltas-list-functions ---
	
	/* DESC  : Generate the deltas-list from filesArr
	 * NEEDS : (VOID)
	 * RETURN: (VOID)
	 */
	function deltaList_generate(){
		$j=0;
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->getProjectTypeFromGivenProject($this->filesArr[$i]['name'])==$this->TYPE_DELTA){
				$this->deltas_list[$j]['id'] = $this->filesArr[$i]['id'];
				$this->deltas_list[$j]['name'] = $this->filesArr[$i]['name'];
				$this->deltas_list[$j]['selected'] = $this->filesArr[$i]['selected'];
				$j++;
			}
		}
	}
	
	/* DESC  : Select a delta with a given delta-name
	 * NEEDS : A delta-name (STRING)
	 * RETURN: (VOID)
	 */
	function deltaList_selectAnProject($delta_name){
		for($i=0;$i<count($this->deltas_list);$i++){
			if($this->deltas_list[$i]['name']==$delta_name){
				$this->deltas_list[$i]['selected'] = true;
			}else{
				$this->deltas_list[$i]['selected'] = false;
			}
		}
	}
	
	/* DESC  : Get all deltas from an given project
	 * NEEDS : A project-name (STRING)
	 * RETURN: deltas_list-Array (ARRAY)
	 */
	function deltaList_getAllDeltasToAGivenProject($project_name){
		if($this->getProjectTypeFromGivenProject($project_name)==$this->TYPE_DELTA){
			$project_name = $this->getProjectThatBelongsToAGivenDelta($project_name);
		}elseif($this->getProjectTypeFromGivenProject($project_name)==$this->TYPE_COMPARE){
			$project_name = $this->compareList_getProjectNameFromCompareName($project_name);
			if($project_name==""){
				$project_name = $this->getProjectThatBelongsToAGivenDelta($this->compareList_getDeltaNameFromCompareName($project_name,1));
			}
		}
		
		for($i=0;$i<count($this->deltas_list);$i++){
			if($this->getProjectThatBelongsToAGivenDelta($this->deltas_list[$i]['name'])==$project_name){
				$deltas_list_new[$i]['id'] = $this->deltas_list[$i]['id'];
				$deltas_list_new[$i]['name'] = $this->deltas_list[$i]['name'];
				$deltas_list_new[$i]['selected'] = $this->deltas_list[$i]['selected'];
			}
		}
		return $deltas_list_new;
	}
	
// --- Compare-list-functions ---
	
	/* DESC  : Generate the compares-list from filesArr
	 * NEEDS : (VOID)
	 * RETURN: (VOID)
	 */
	function compareList_generate(){
		$j=0;
		for($i=0;$i<count($this->filesArr);$i++){
			if($this->getProjectTypeFromGivenProject($this->filesArr[$i]['name'])==$this->TYPE_COMPARE){
				$this->compares_list[$j]['id'] = $this->filesArr[$i]['id'];
				$this->compares_list[$j]['name'] = $this->filesArr[$i]['name'];
				$this->compares_list[$j]['selected'] = $this->filesArr[$i]['selected'];
				$j++;
			}
		}
	}
	
	/* DESC  : Get the project_name from a given compare project
	 * NEEDS : A compare-name (STRING)
	 * RETURN: (VOID)
	 */
	private function compareList_getProjectNameFromCompareName($compare_name){
		$arr = explode("__",$compare_name);
		if($this->getProjectTypeFromGivenProject($arr[0])==$this->TYPE_PROJECT){
			return $arr[0];
		}elseif($this->getProjectTypeFromGivenProject($arr[1])==$this->TYPE_PROJECT){
			return $arr[1];
		}else{
			return "";
		}
	}
	
	/* DESC  : Get the project_name from a given compare project
	 * NEEDS : A compare-name (STRING),
	 *         A delta-nr (its possible, that a compare-project have
	 *         two deltas but no "normal" project). You can choose between
	 *         1 or 2.
	 * RETURN: (VOID)
	 */
	private function compareList_getDeltaNameFromCompareName($compare_name,$nr){
		$arr = explode("__",$compare_name);
		if($this->getProjectTypeFromGivenProject($arr[0])==$this->TYPE_DELTA && $this->getProjectTypeFromGivenProject($arr[1])==$this->TYPE_DELTA){
			if($nr==1){
				return $arr[0];
			}elseif($nr==2){
				return $arr[1];
			}else{
				return "";
			}
		}elseif($this->getProjectTypeFromGivenProject($arr[0])==$this->TYPE_PROJECT){
			return $arr[0];
		}else{
			return $arr[1];
		}
	}
	
	/* DESC  : Select the correct project_list-entry and delta_list-entry with a given
	 *         compare_name
	 * NEEDS : A compare-name (STRING)
	 * RETURN: (VOID)
	 */
	function compareList_selectCorrectEntriesInProjectListAndDeltaList($compare_name){
		//Select the correct project
		$project_name = $this->compareList_getProjectNameFromCompareName($compare_name);
		if($project_name==""){
			$this->projectList_selectAnProject($this->getProjectThatBelongsToAGivenDelta($this->compareList_getDeltaNameFromCompareName($compare_name,1)));
		}else{
			$this->projectList_selectAnProject($project_name);
		}
		
		//Select the correct delta
		$this->deltaList_selectAnProject($this->getProjectThatBelongsToAGivenDelta($this->compareList_getDeltaNameFromCompareName($compare_name,1)));
	}
}
?>