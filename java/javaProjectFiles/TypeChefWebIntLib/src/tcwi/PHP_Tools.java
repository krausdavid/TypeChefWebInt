package tcwi;

import tcwi.exception.Exceptions;
import tcwi.tools.Tools;
import tcwi.xml.Parser;

public class PHP_Tools {
	private static final String VERSION = "0.0.0.7";
	private static final String AUTHORS = "EifX & hulllemann";
	
	public static void main(String[] args) {
		if(args.length<=2){
			System.out.println("Help - PHP_Tools "+VERSION+" by "+AUTHORS);
			System.out.println("----------------------------------------------------");
			System.out.println("\nUsage: PHP_Tools [FUNCTION] [GLOBAL_SETTINGS] [OPTIONAL1] [OPTIONAL2] ...");
			System.out.println("\n[FUNCTION]");
			System.out.println("     Select the tool\n     Current available tools are:");
			System.out.println("          FINDPROJECTNAME - Check, if the given project name is free,");
			System.out.println("                            an if it is not free, it returns an alternative name.");
			System.out.println("                            It needs one optional parameter!");
			System.out.println("[GLOBAL_SETTINGS]");
			System.out.println("     Absolute Path for the global_settings.xml\n     (include the name of the settings file)\n");
			System.out.println("[OPTIONAL1] ...");
			System.out.println("     Optional parameters, needed for some functions\n");
		}else{
			String function = args[0];
			String globalSettings = args[1];
			
			Parser parser = new Parser(globalSettings);
			
			if(function.equals("FINDPROJECTNAME")){//TODO!!! REWRITE
				if(args.length!=3){
					Exceptions.throwException(13, null, true, "");
				}else{
					if(args[2].matches("[a-zA-Z0-9._\\-]*")){
						System.out.println(Tools.findAFreeProjectName(args[2], parser.getSetting_ProjectPath()));
					}else{
						Exceptions.throwException(14, null, true, args[2]);
					}
				}
			}
		}
	}

}
