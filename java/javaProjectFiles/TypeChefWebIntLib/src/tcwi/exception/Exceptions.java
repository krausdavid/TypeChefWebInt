package tcwi.exception;

import java.util.HashMap;

public class Exceptions {
	private HashMap<Integer, String> exception;
	
	public void Exception(){
		exception = new HashMap<Integer, String>();
		exception.put(1, "ERROR 1: Can't read the setting-file");
		exception.put(2, "ERROR 2: Error during parse the setting-file. Is it malformed?");
		exception.put(3, "ERROR 3: Can't generate and write the javascript file.");
	}
	
	public void throwException(int i, Exception e, boolean isExit, String pathInformation){
		if(pathInformation!=""){
			System.err.println(exception.get(i) + "The Path is: " + pathInformation);
		}else{
			System.err.println(exception.get(i));
		}
		System.err.println();
		e.printStackTrace();
		if(isExit){
			System.exit(i);
		}
	}
}
