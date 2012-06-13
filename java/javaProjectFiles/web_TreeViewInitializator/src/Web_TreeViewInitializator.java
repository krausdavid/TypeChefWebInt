import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

import tcwi.xml.*;
import tcwi.exception.Exceptions;
import tcwi.fileHandler.*;
import tcwi.TCWIFile.CompareFile;
import tcwi.TCWIFile.ErrorFile;
import tcwi.TCWIFile.TCWIFile;

public class Web_TreeViewInitializator {

	private static final String VERSION = "0.3.0.1";
	private static final String AUTHORS = "EifX & hulllemann";
	private static ArrayList<TCWIFile> files;
	private static Check check = new Check();
	private static Exceptions exception;
	private static ArrayList<String> javascript = new ArrayList<String>();
	
	/**
	 * Read the file-list generated by web_ProjectInitializator
	 * @param projectName
	 * @param settingsFile
	 */
	private static void getAllFiles(String projectName, String settingsFile, String projectType, String project_settings_path){
		try{
			if(projectType.equals("normal")){
				files = TCWIFile.createTCWIFileArrayFromErrorFile(project_settings_path);
			}else if(projectType.equals("compare")){
				files = TCWIFile.createTCWIFileArrayFromCompareFile(project_settings_path);
			}else{
				exception.throwException(12, null, true, "");
			}
		}catch(IOException e){
			exception.throwException(1, e, true, "");
		}
	}
	
	/**
	 * Check a given folder for failure dbg-files.
	 * @param path
	 * @return
	 */
	private static boolean isAFailFolder(String path, String projectType){
		ArrayList<TCWIFile> filesNew = new ArrayList<TCWIFile>();
		for(int i=0;i<files.size();i++){
			if(projectType.equals("normal")){
				if(((ErrorFile) files.get(i)).getPath().contains(path)){
					filesNew.add((ErrorFile) files.get(i));
				}
			}else if(projectType.equals("compare")){
				if(((CompareFile) files.get(i)).getPath().contains(path)){
					filesNew.add((CompareFile) files.get(i));
				}
			}else{
				exception.throwException(12, null, true, "");
			}
		}
		for(int i=0;i<filesNew.size();i++){
			if(projectType.equals("normal")){
				if(((ErrorFile) filesNew.get(i)).haveErrors()){
					if(((ErrorFile) filesNew.get(i)).isHaveNoDBG()){
						return false;
					}else{
						return true;
					}
				}
			}else if(projectType.equals("compare")){
				return ((CompareFile) filesNew.get(i)).haveChanges();
			}else{
				exception.throwException(12, null, true, "");
			}
		}
		return false;
	}

	/**
	 * Write the output filefalse
	 * @param path
	 * @param prettyOutput
	 */
	private static void writeTxt(String path){
		try{
			File f = new File(path);
			f.delete();
			RandomAccessFile file = new RandomAccessFile(path,"rw");
			for(int i=0;i<javascript.size();i++){
				file.writeBytes(javascript.get(i)+"\r\n");
			}
			file.close();
		}catch (IOException e){
			exception.throwException(3, e, true, path);
		}
	}

	/**
	 * Get the right icon for the treeview
	 * @param path
	 * @param projectType
	 * @return
	 */
	private static String getIcon(String path, String projectType, String dirType){
		if(projectType.equals("normal")){
			if(!isAFailFolder(path,projectType)){
				return "folder"+dirType+"ok";
			}else{
				return "folder"+dirType+"fail";
			}
		}else if(projectType.equals("compare")){
			if(!isAFailFolder(path,projectType)){
				return "folder"+dirType+"identical";
			}else{
				return "folder"+dirType+"difference";
			}
		}else{
			exception.throwException(12, null, true, "");
			return "";
		}
	}
	
	/**
	 * Get the right icon for the treeview
	 * @param file
	 * @param projectType
	 * @return
	 */
	private static String getIcon(TCWIFile file, String projectType){
		if(projectType.equals("normal")){
			if(!((ErrorFile) file).haveErrors()){
				return "fileok";
			}else{
				if(((ErrorFile) file).isHaveNoDBG()){
					return "fileempty";
				}else{
					return "filefail";
				}
			}
		}else if(projectType.equals("compare")){
			if(!((CompareFile) file).haveChanges()){
				return "fileidentical";
			}else{
				return "filedifference";
			}
		}else{
			exception.throwException(12, null, true, "");
			return "";
		}
	}

	/**
	 * Checks the difference between the old and the new path and
	 * deletes or creates folders
	 * @param oldArr
	 * @param newArr
	 * @return
	 */
	private static int[] dirDecision(String[] oldArr, String[] newArr){
		int oldLen = oldArr.length-1;
		int newLen = newArr.length-1;
		int[] output = {0,0};
		
		if(oldLen>newLen){
			for(int i=0;i<oldLen;i++){
				if(i<newLen){
					if(!oldArr[i].equals(newArr[i])){
						output[0] = newLen-i;
						output[1] = i;
						return output;
					}
				}
			}
			return output;
		}else if(oldLen==newLen){
			for(int i=0;i<oldLen;i++){
				if(i<newLen){
					if(!oldArr[i].equals(newArr[i])){
						output[0] = oldLen-i;
						output[1] = i;
						return output;
					}
				}
			}
			return output;
		}else{
			for(int i=0;i<newLen;i++){
				if(i<oldLen){
					if(!newArr[i].equals(oldArr[i])){
						output[0] = newLen-i;
						output[1] = i;
						return output;
					}
				}
			}
			output[0] = newLen-oldLen;
			output[1] = oldLen;
			return output;
		}
	}
	
	/**
	* This method cleans a string. Only letters and numbers are excepted in a string, all other
	* values are replaced by an underscore.
	* @param str
	* @return a clean String
	*/
	private static String cleanStr(String str){
		String newStr = "";
		for(int i=0;i<str.length();i++){
			if(((str.charAt(i)>=65)&&(str.charAt(i)<=90))||((str.charAt(i)>=97)&&(str.charAt(i)<=122))||((str.charAt(i)>=48)&&(str.charAt(i)<=57))){
				newStr += str.charAt(i);
			}else{
				newStr += "_";
			}
		}
		return "dir"+newStr;
	}
	
	/**
	 * Main Method to generate the JS-Tree
	 * @param projectName
	 * @param projectType
	 * @param projectPath
	 */
	private static void generateJSTree(String projectName, String projectType, String projectPath){
		ArrayList<String> relativeFiles = new ArrayList<String>();
		for(int i=0;i<files.size();i++){
			if(projectType.equals("normal")){
				relativeFiles.add(((ErrorFile) files.get(i)).getPath().substring(projectPath.length()+1));
			}else if(projectType.equals("compare")){
				relativeFiles.add(((CompareFile) files.get(i)).getPath().substring(projectPath.length()+1));
			}else{
				exception.throwException(12, null, true, "");
			}
		}
		
		String[] oldArr = {""};

		for(int i=0;i<relativeFiles.size();i++){
			String newPath = relativeFiles.get(i);
			
			String[] pathArr;
			pathArr = relativeFiles.get(i).split(check.folderSeparator()+"");

//			//If the path has changed, draw the missing parts
			String p = "";
			int[] dir = dirDecision(oldArr, pathArr);
			
			//Write folders
			if(dir[0]>0){
				for(int j=dir[1];j<(dir[0]+dir[1]);j++){
					if(j==0){
						javascript.add(cleanStr(pathArr[0])+" = insFld(foldersTree, gFld(\""+pathArr[0]+"\", \"\"))");
					}else{
						javascript.add(cleanStr(pathArr[j])+" = insFld("+cleanStr(pathArr[j-1])+", gFld(\""+pathArr[j]+"\", \"\"))");
					}
					
					
					for(int k=0;k<=j;k++){
						p+=check.folderSeparator()+pathArr[k];
					}
					p = projectPath+p;
					
					javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \""+getIcon(p,projectType,"open")+".gif\"");
					javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \""+getIcon(p,projectType,"closed")+".gif\"");
				}
			}else{
				//p = oldP;
			}
			
			//Write files
			newPath = newPath.replace("\\", "/");
			newPath = newPath.replace(" ", "_");
			
			//Print the files!
			if(pathArr.length==1){
				javascript.add("doc"+i+" = insDoc(foldersTree, gLnk(\"S\", \""+pathArr[pathArr.length-1]+".c\", P1+\""+newPath+"\"+P2))");
			}else{
				javascript.add("doc"+i+" = insDoc("+cleanStr(pathArr[pathArr.length-2])+", gLnk(\"S\", \""+pathArr[pathArr.length-1]+".c\", P1+\""+newPath+"\"+P2))");
			}
			
			javascript.add("doc"+i+".iconSrc = ICONPATH + \""+getIcon(files.get(i),projectType)+".gif\"");
			javascript.add("doc"+i+".prependHTML = C1+\""+i+"\"+C2");
			
			oldArr = pathArr;
		}
	}
	
	/**
	 * This Method draws the javascript-header
	 * @param projectFullNameAndVersion
	 * @param iconPath
	 * @param prePath
	 * @param postPath
	 * @param projectType
	 * @param failureProject
	 */
	private static void generateJSHeader(String projectFullNameAndVersion, String iconPath, String prePath, String postPath, String projectType, boolean failureProject){
		javascript.add("USETEXTLINKS = 1");
		javascript.add("STARTALLOPEN = 0");
		javascript.add("USEICONS = 1");
		javascript.add("BUILDALL = 0");
		javascript.add("USEFRAMES = 0");
		javascript.add("PRESERVESTATE = 1");
		javascript.add("HIGHLIGHT = 0");
		javascript.add("P1 = \""+prePath+"\"");
		javascript.add("P2 = \""+postPath+"\"");
		javascript.add("C1 = \"<td valign=middle><input type=checkbox id=\\\"chkbox\"");
		javascript.add("C2 = \"\\\"></td>\"");
		javascript.add("ICONPATH = '"+iconPath+"'");
		javascript.add("MAX_LENGTH = "+files.size());
		
		javascript.add("foldersTree = gFld(\"<i>"+projectFullNameAndVersion+"</i>\", \"\")");
		javascript.add("foldersTree.treeID = \"Frameset\"");
		
		if(projectType.equals("normal")){
			if(!failureProject){
				javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenok.gif\"");
				javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedok.gif\"");
			}else{
				javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenfail.gif\"");
				javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedfail.gif\"");
			}
		}else if(projectType.equals("compare")){
			if(!failureProject){
				javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenidentical.gif\"");
				javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedidentical.gif\"");
			}else{
				javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopendifference.gif\"");
				javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"foldercloseddifference.gif\"");
			}
		}else{
			exception.throwException(12, null, true, "");
		}
	}

	/**
	 * Main function
	 * @param args
	 */
	public static void main(String[] args) {
		if(args.length!=2){
			System.out.println("Help - web_TreeViewInitializator "+VERSION+" by "+AUTHORS);
			System.out.println("----------------------------------------------------");
			System.out.println("\nUsage: web_TreeViewInitializator [PROJECTNAME] [GLOBAL_SETTINGS]");
			System.out.println("\n[PROJECTNAME]");
			System.out.println("\n     Project name\n");
			System.out.println("\n[GLOBAL_SETTINGS]");
			System.out.println("\n     Absolute Path for the global_settings.xml\n     (include the name of the settings file)\n");
		}else{
			System.out.println("\nRead needed variables...");
			String projectName = args[0];
			String globalSettings = args[1];
			
			//Init the XMLParser
			Parser settingsParser = new Parser(globalSettings);
			String WebIntProjectsPath = settingsParser.getSetting_ProjectPath();
			String TreeViewPath = settingsParser.getSetting_TreeviewPath();
			String TreeViewIconsPath = settingsParser.getSetting_TreeviewIconsPath();
			String WebsiteDefaultURL = settingsParser.getSetting_WebsiteDefaultURI();
			
			//Read the project dir
			String project_settings_path = WebIntProjectsPath+check.folderSeparator()+projectName+".project";
			String project_settings_xml_path = WebIntProjectsPath+check.folderSeparator()+projectName+".project.xml";
			
			//If the project have minimal one error, the main-folder in the tree-list is a fail folder
			Parser parser = new Parser(project_settings_xml_path);
			boolean failureProject = parser.getSetting_ProjectFailureProject().equals("true");
			
			String projectPath = parser.getSetting_ProjectBasePath();
			String projectType = parser.getSetting_ProjectType();
			String projectVersion = parser.getSetting_ProjectVersion();
			String projectFullName = parser.getSetting_ProjectFullname();
			
			//Do the work
			System.out.println("Read folder tree...");
			getAllFiles(projectName,globalSettings,projectType,project_settings_path);

			System.out.println("Build JavaScript-File...");
			
			generateJSHeader(projectFullName+" "+projectVersion, TreeViewIconsPath, WebsiteDefaultURL+"/project?choice=view&files=", "&project="+projectName,projectType, failureProject);
			generateJSTree(projectName,projectType,projectPath);
			
			System.out.println("Save folder tree...");
			
			//Build the path for the JSON-path
			writeTxt(TreeViewPath+check.folderSeparator()+projectName+".js");
			System.out.println("DONE!");
		}
	}

}
