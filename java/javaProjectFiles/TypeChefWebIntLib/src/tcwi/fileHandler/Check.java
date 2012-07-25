package tcwi.fileHandler;
import java.io.File;

public class Check {
	
	/**
	 * This method returns the OS typical folder separator
	 * @return The separator
	 */
	public static String folderSeparator(){
		File f = new File("");
		if(f.getAbsolutePath().charAt(0)=='/'){
			return "/";
		}else{
			return "\\";
		}
		
	}
	
	/**
	 * Checks whether the given project name is already taken
	 * @param projectName
	 * @param projectPath
	 * @return
	 */
	public boolean projectExist(String projectName, String projectPath){
		File f = new File(projectPath+folderSeparator()+projectName+".project.xml");
		return f.exists();
	}

	/**
	 * Checks whether the given project-delta name is already taken
	 * @param projectName
	 * @param projectPath
	 * @return
	 */
	public boolean projectDeltaExist(String projectName, String projectPath){
		File f = new File(projectPath+folderSeparator()+projectName+".deltaproject.xml");
		return f.exists();
	}
	
}
