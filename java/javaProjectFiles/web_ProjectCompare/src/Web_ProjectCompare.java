import java.util.ArrayList;

import tcwi.TCWIFile.ErrorFile;
import tcwi.fileHandler.Check;
import tcwi.xml.Parser;

public class Web_ProjectCompare {
	private static final String VERSION = "0.0.0.1";
	private static final String AUTHORS = "EifX & hulllemann";
	private static Parser parser;
	private static Check check = new Check();
	
	public static void main(String[] args) {
		if(args.length!=3){
			System.out.println("Help - Web_ProjectCompare "+VERSION+" by "+AUTHORS);
			System.out.println("----------------------------------------------------");
			System.out.println("\nUsage: Web_ProjectCompare [MAINPROJECT] [COMPAREPROJECT] [GLOBAL_SETTINGS]");
			System.out.println("\n[MAINPROJECT]");
			System.out.println("     Base-Project\n");
			System.out.println("[COMPAREPROJECT]");
			System.out.println("     Compare-Project\n");
			System.out.println("[GLOBAL_SETTINGS]");
			System.out.println("     Absolute Path for the global_settings.xml\n     (include the name of the settings file)\n");
		}else{
			String mainProject = args[0];
			String compareProject = args[1];
			String globalSettings = args[2];
			
			System.out.println("Starting compare "+mainProject+" with "+compareProject);

			parser = new Parser(globalSettings);
			String[] xpath = {"settings","global","projects","path"};
			
			String projectPath = "";
			
			try{
				projectPath = parser.read_setting(xpath);
			} catch (Exception e) {
				System.out.println("ERROR by reading the settings-file.");
				System.exit(-1);
			}
			
			try{
				ErrorFile errFile = new ErrorFile(null,null,null,null,null);

				ArrayList<ErrorFile> mainProjectErrArr = ErrorFile.createErrorFileArray(projectPath + check.folderSeparator() + mainProject + ".project");
				ArrayList<ErrorFile> compareProjectErrArr = ErrorFile.createErrorFileArray(projectPath + check.folderSeparator() + compareProject + ".project");
			}catch (Exception e){
				System.out.println("ERROR by reading the project-files.");
			}
			
			
		}
	}

}
