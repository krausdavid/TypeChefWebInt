import java.io.File;
import tcwi.fileHandler.Check;
import tcwi.xml.Parser;


public class Web_DeleteProject {
	private static final String VERSION = "0.0.1.2";
	private static final String AUTHORS = "EifX & hulllemann";
	private static Parser parser;
	
	public static void main(String[] args) {
		if(args.length!=2){
			System.out.println("Help - web_DeleteProject "+VERSION+" by "+AUTHORS);
			System.out.println("----------------------------------------------------");
			System.out.println("\nUsage: web_DeleteProject [PROJECTNAME] [GLOBAL_SETTINGS]");
			System.out.println("\n[PROJECTNAME]");
			System.out.println("\n     Project name\n");
			System.out.println("\n[GLOBAL_SETTINGS]");
			System.out.println("\n     Absolute Path for the global_settings.xml\n     (include the name of the settings file)\n");
		}else{
			
			//Init the Parser
			parser = new Parser(args[1]);
			String webIntProjectsPath = parser.getSetting_ProjectPath();
			String webIntTreeviewPath = parser.getSetting_TreeviewPath();
			
			File f = new File(webIntTreeviewPath + Check.folderSeparator() + args[0] + ".js");
			f.delete();
			f = new File(webIntTreeviewPath + Check.folderSeparator() + args[0] + ".nochk.js");
			f.delete();
			f = new File(webIntTreeviewPath + Check.folderSeparator() + args[0] + ".err.js");
			f.delete();
			f = new File(webIntTreeviewPath + Check.folderSeparator() + args[0] + ".err.nochk.js");
			f.delete();
			f = new File(webIntProjectsPath + Check.folderSeparator() + args[0] + ".project.xml");
			f.delete();
			f = new File(webIntProjectsPath + Check.folderSeparator() + args[0] + ".lst");
			f.delete();
			System.out.println("Project "+ args[0] +" successfully deleted!");
		}
	}

}
