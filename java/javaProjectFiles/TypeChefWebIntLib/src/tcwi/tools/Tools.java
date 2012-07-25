package tcwi.tools;

import tcwi.exception.Exceptions;
import tcwi.fileHandler.Check;

public class Tools {
	private static Check check = new Check();
	/**
	 * Returns a correct formatted number
	 * @param str
	 * @return
	 */
	public static String correctCalendarForm(int i){
		String str = i+"";
		if(str.length()==1){
			return "0"+str;
		}else{
			return str;
		}
	}
	
	/**
	 * Returns an unique project name. If the given project-name is not unique,
	 * a number in the project-name count up, up to 1000000.
	 * @param str
	 * @param path
	 * @return
	 */
	public static String findAFreeProjectName(String str, String path){
		int i = 1;
		String newProjectName = str+"_"+i;
		while(check.projectDeltaExist(newProjectName, path)){
			newProjectName = str+"_"+i;
			i++;
			if(i > 1000000){
				Exceptions.throwException(10, null, true, newProjectName);
			}
		}
		return newProjectName;
	}
}
