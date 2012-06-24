import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;

import tcwi.TCWIFile.ErrorFile;
import tcwi.exception.Exceptions;
import tcwi.fileHandler.Check;
import tcwi.tools.Tools;
import tcwi.xml.Parser;

public class Web_ProjectInitializator {
	private static final String VERSION = "0.1.3.1";
	private static final String AUTHORS = "EifX & hulllemann";
	private static ArrayList<ErrorFile> files = new ArrayList<ErrorFile>();
	private static Check check = new Check();
	private static Parser parser;
	private static boolean failureProject = false;
	private static Exceptions exception = new Exceptions();

	/**
	 * Recursive method for get all files in a given path ends with ".c"
	 * It saves this files into <tt>files</tt>
	 * @param path
	 * @return An error-string
	 */
	private static String getAllFiles(String path){
		File file = new File(path);
		File[] fileList = file.listFiles();
		try{
			for(int i=0;i<fileList.length;i++){
				if(fileList[i].isDirectory()){
					getAllFiles(fileList[i].getAbsolutePath());
				}else{
					if(fileList[i].toString().endsWith(".c")){
						try{
							String str = fileList[i].getAbsolutePath().substring(0,fileList[i].getAbsolutePath().length()-2);
							ErrorFile errFile = new ErrorFile(str,check.failFlags(str));
							files.add(errFile);
						}catch (IOException e){
							return fileList[i].getAbsolutePath();
						}
					}
				}
			}
		}catch (Exception e){
			return path;
		}
		return "";
	}
	
	/**
	 * Write the .project file
	 * @param path
	 * @param projectName
	 */
	private static void writeProjectFile(String path, String projectName){
		try{
			File f = new File(path+Check.folderSeparator()+projectName+".project");
			f.delete();
			RandomAccessFile file = new RandomAccessFile(path+Check.folderSeparator()+projectName+".project","rw");
			for(int i=0;i<files.size();i++){
				//Check if the project has errors. The result will be saved in the project.xml
				if(failureProject==false){
					if(files.get(i).haveErrors()){
						failureProject = true;
					}
				}
				file.writeBytes(files.get(i)+"\r\n");
			}
			file.close();
		}catch (IOException e){
			exception.throwException(4, e, true, path);
		}
	}

	/**
	 * Write the .project.xml file
	 * @param path
	 * @param projectName
	 * @param projectPath
	 */
	private static void writeProjectXMLFile(String path, String projectName, String projectFullName, String projectVersion, String projectAuthor, String projectPath, String projectHasDeltas, String projectDeltaMain){
		try{
			Calendar c = new GregorianCalendar();
			String month = Tools.correctCalendarForm(c.get(GregorianCalendar.MONTH)+1);
			String day = Tools.correctCalendarForm(c.get(GregorianCalendar.DAY_OF_MONTH));
			String hour = Tools.correctCalendarForm(c.get(GregorianCalendar.HOUR_OF_DAY));
			String minute = Tools.correctCalendarForm(c.get(GregorianCalendar.MINUTE));
			String second = Tools.correctCalendarForm(c.get(GregorianCalendar.SECOND));

			File f = new File(path+Check.folderSeparator()+projectName+".project.xml");
			f.delete();
			RandomAccessFile file = new RandomAccessFile(path+Check.folderSeparator()+projectName+".project.xml","rw");
			file.writeBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");//TODO: Datei wird nicht als UTF-8 abgespeichert
			file.writeBytes("<settings>\r\n");
			file.writeBytes("     <global>\r\n");
			file.writeBytes("          <project idname=\""+projectName+"\" fullname=\""+projectFullName+"\" version=\""+projectVersion+"\" path=\""+projectPath+"\" failureProject=\""+failureProject+"\" type=\"normal\" />\r\n");
			if(projectHasDeltas.equals("true")){
				file.writeBytes("          <delta hasDeltas=\"true\" mainProject=\""+projectDeltaMain+"\" />\r\n");
			}else{
				file.writeBytes("          <delta hasDeltas=\"false\" mainProject=\"_\" />\r\n");
			}
			file.writeBytes("          <init builder=\""+projectAuthor+"\" buildday=\""+c.get(GregorianCalendar.YEAR)+"-"+month+"-"+day+"\" buildtime=\""+hour+":"+minute+":"+second+"\" />\r\n");
			file.writeBytes("     </global>\r\n");
			file.writeBytes("</settings>\r\n");
			file.close();
		}catch (IOException e){
			exception.throwException(4, e, true, path);
		}
	}
	
	/**
	 * Main class
	 * @param args
	 */
	public static void main(String[] args) {
		if(args.length!=7){
			System.out.println("Help - Web_ProjectInitializator "+VERSION+" by "+AUTHORS);
			System.out.println("----------------------------------------------------");
			System.out.println("\nUsage: Web_ProjectInitializator [PROJECTPATH] [PROJECTNAME] [PROJECTFULLNAME] ");
			System.out.println("                                [PROJECTVERSION] [PROJECTAUTHOR] [GLOBAL_SETTINGS]");
			System.out.println("\n[PROJECTPATH]");
			System.out.println("     Absolute Path for scan for TypeChef-Files\n");
			System.out.println("[PROJECTNAME]");
			System.out.println("     Project shortcut-name. It must be unique!\n");
			System.out.println("[PROJECTFULLNAME]");
			System.out.println("     Project name\n");
			System.out.println("[PROJECTVERSION]");
			System.out.println("     Project version\n");
			System.out.println("[PROJECTAUTHOR]");
			System.out.println("     Project author\n");
			System.out.println("[DELTAPROJECT]");
			System.out.println("     true or false, if the project has deltas\n");
			System.out.println("[DELTAMAIN]");
			System.out.println("     The main-project who belongs to this delta. Type _ if this is the main-project\n");
			System.out.println("[GLOBAL_SETTINGS]");
			System.out.println("     Absolute Path for the global_settings.xml\n     (include the name of the settings file)\n");
		}else{
			String path = args[0];
			String projectName = args[1];
			String projectFullName = args[2];
			String projectVersion = args[3];
			String projectAuthor = args[4];
			String projectHasDeltas = args[5];
			String projectDeltaMain = args[6];
			String settingFile = args[7];
			
			System.out.println("Starting initialization from project "+projectName+"...");
			
			long time = System.currentTimeMillis();

			parser = new Parser(settingFile);
			String projectPath = parser.getSetting_ProjectPath();
			
			if(check.uniqueCheck(projectName, projectPath)){
				System.out.println("Project name is OK!");
			}else{
				exception.throwException(5, null, true, "");
			}
			
			//Removes an additional folder separator from an path end
			//ex. /app/home/foo/bar/ --> /app/home/foo/bar
			if(path.endsWith(Check.folderSeparator()+"")){
				path = path.substring(0,path.length()-1);
			}
			
			File file = new File(path);
			if(!file.exists()){
				exception.throwException(7, null, true, path);
			}
			
			String str = getAllFiles(path);
			if(str.equals("")){
				System.out.println("Initialization DONE!");
			}else{
				exception.throwException(6, null, true, str);
			}
			
			System.out.println("Sort files...");
			
			ErrorFile[] errFiles = new ErrorFile[files.size()];
			for(int i=0;i<files.size();i++){
				errFiles[i] = files.get(i);
			}

			Arrays.sort(errFiles);
			files.clear();
			for(int i=0;i<errFiles.length;i++){
				files.add(errFiles[i]);
			}

			System.out.println("Sorting DONE!");
			System.out.println("Writing down the project file...");
			
			if(projectDeltaMain.equals("_")){
				writeProjectFile(projectPath,projectName);
				writeProjectXMLFile(projectPath,projectName,projectFullName,projectVersion,projectAuthor,path,projectHasDeltas,projectDeltaMain);
			}else{
				String newProjectName = Tools.findAFreeProjectName(projectDeltaMain, path, true);
				writeProjectFile(projectPath,newProjectName);
				writeProjectXMLFile(projectPath,newProjectName,projectFullName,projectVersion,projectAuthor,path,projectHasDeltas,projectDeltaMain);
			}
			
			System.out.println("Writing DONE!\nScript DONE!");
			System.out.printf("Duration: %.2f sec\n",(System.currentTimeMillis()-time)/1000.0);
		}
	}

}
