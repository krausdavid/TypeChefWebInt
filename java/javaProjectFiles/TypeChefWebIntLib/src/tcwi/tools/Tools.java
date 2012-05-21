package tcwi.tools;

import tcwi.exception.Exceptions;
import tcwi.fileHandler.Check;

public class Tools {
	private static Check check = new Check();
	private static Exceptions exception = new Exceptions();
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
		String newProjectName = str;
		if(!check.uniqueCheck(str, path)){
			int i = 0;
			while(!check.uniqueCheck(str, path)){
				newProjectName = str+i;
				i++;
				if(i > 1000000){
					exception.throwException(10, null, true, newProjectName);
				}
			}
		}
		return str;
	}
}
