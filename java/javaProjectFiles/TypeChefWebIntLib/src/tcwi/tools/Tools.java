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
	public static String findAFreeProjectName(String str, String path, boolean searchAFreeDelta){
		String newProjectName = str;
		if(searchAFreeDelta){
			newProjectName = str+"_d";
		}
		if(!check.uniqueCheck(newProjectName, path)){
			int i = 1;
			while(!check.uniqueCheck(newProjectName, path)){
				newProjectName = str+"_"+i;
				i++;
				if(i > 1000000){
					Exceptions.throwException(10, null, true, newProjectName);
				}
			}
		}
		return newProjectName;
	}
}
