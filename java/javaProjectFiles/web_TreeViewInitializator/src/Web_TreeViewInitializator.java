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

	private static final String VERSION = "0.1.8.4";
	private static final String AUTHORS = "EifX & hulllemann";
	private static ArrayList<String> javascript = new ArrayList<String>();
	private static ArrayList<TCWIFile> files;
	private static String folderSeparator;
	private static Check check = new Check();
	private static boolean failureProject = false;
	private static String projectPath;
	private static String project_settings_path;
	private static String project_settings_xml_path;
	private static Exceptions exception;
	private static String projectType;
	
	/**
	 * Read the file-list generated by web_ProjectInitializator
	 * @param projectName
	 * @param settingsFile
	 */
	public static void getAllFiles(String projectName, String settingsFile){
		String[] xpathProject = null;
		try{
			//If the project have minimal one error, the main-folder in the tree-list is a fail folder
			Parser projectParser = new Parser(project_settings_xml_path);

			xpathProject = new String[]{"settings","global","projects","failureProject"};
			if(projectParser.read_setting(xpathProject).equals("true")){
				failureProject = true;
			}else{
				failureProject = false;
			}
			if(projectType.equals("normal")){
				files = TCWIFile.createTCWIFileArrayFromErrorFile(project_settings_path);
			}else if(projectType.equals("compare")){
				files = TCWIFile.createTCWIFileArrayFromCompareFile(project_settings_path);
			}else{
				exception.throwException(12, null, true, "");
			}
		}catch(IOException e){
			exception.throwException(1, e, true, "");
		} catch (Exception e) {
			if(xpathProject!=null){
				String path = "";
				for(int i=0;i<xpathProject.length;i++){
					path += xpathProject[i]+" ";
				}
				exception.throwException(2, e, true, path);
			}else{
				exception.throwException(2, e, true, "");
			}
		}
	}
	
	/**
	 * Check a given folder for failure dbg-files.
	 * @param path
	 * @return
	 */
	public static boolean isAFailFolder(String path){
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
	public static void writeTxt(String path){
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
	 * This method cleans a string. Only letters and numbers are excepted in a string, all other
	 * values are replaced by an underscore.
	 * @param str
	 * @return a clean String
	 */
	public static String cleanStr(String str){
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
	 * This Method create the javascript-treeview
	 * It takes a sorted path-list. Every path will build separatly.
	 * @param path
	 */
	public static void js_tree_new(String projectName, String defaultURI){
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
			int notEqual = -1;
			String newPath = relativeFiles.get(i);
			
			String[] pathArr;
			pathArr = relativeFiles.get(i).split(check.folderSeparator()+"");

			//Search for differences between the new and the last file
			for(int j=0;j<pathArr.length;j++){
				if(oldArr.length>j){
					if(!pathArr[j].equals(oldArr[j])){
						notEqual = j;
						break;
					}
				}else{
					notEqual = j;
					break;
				}
			}
			
			//If a file exists in the tree, do nothing
			if(notEqual==-1){
				break;
			}
			
			//If the path has changed, draw the missing parts
			if(pathArr.length-1!=notEqual){
				for(int j=notEqual;j<pathArr.length-1;j++){
					if(j==0){
						javascript.add(cleanStr(pathArr[0])+" = insFld(foldersTree, gFld(\""+pathArr[0]+"\", \"\"))");
					}else{
						javascript.add(cleanStr(pathArr[j])+" = insFld("+cleanStr(pathArr[j-1])+", gFld(\""+pathArr[j]+"\", \"\"))");
					}
					//Draw foldericons
					String p = "";
					for(int k=0;k<=j;k++){
						p+=folderSeparator+pathArr[k];
					}
					p = projectPath+p;
					if(projectType.equals("normal")){
						if(!isAFailFolder(p)){
							javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \"folderopenok.gif\"");
							javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \"folderclosedok.gif\"");
						}else{
							javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \"folderopenfail.gif\"");
							javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \"folderclosedfail.gif\"");
						}
					}else if(projectType.equals("compare")){
						if(!isAFailFolder(p)){
							javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \"folderopenidentical.gif\"");
							javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \"folderclosedidentical.gif\"");
						}else{
							javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \"folderopendifference.gif\"");
							javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \"foldercloseddifference.gif\"");
						}
					}else{
						exception.throwException(12, null, true, "");
					}
				}
			}
			
			newPath = newPath.replace("\\", "/");
			newPath = newPath.replace(" ", "_");

			//Print the files!
			if(pathArr.length==1){
				javascript.add("doc"+i+" = insDoc(foldersTree, gLnk(\"S\", \""+pathArr[pathArr.length-1]+"\", \""+defaultURI+"/project?choice=view&files="+newPath+"&project="+projectName+"\"))");
			}else{
				javascript.add("doc"+i+" = insDoc("+cleanStr(pathArr[pathArr.length-2])+", gLnk(\"S\", \""+pathArr[pathArr.length-1]+"\", \""+defaultURI+"/project?choice=view&files="+newPath+"&project="+projectName+"\"))");
			}

			//Draw fileicons
			if(projectType.equals("normal")){
				if(!((ErrorFile) files.get(i)).haveErrors()){
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"fileok.gif\"");
				}else{
					if(((ErrorFile) files.get(i)).isHaveNoDBG()){
						javascript.add("doc"+i+".iconSrc = ICONPATH + \"fileempty.gif\"");
					}else{
						javascript.add("doc"+i+".iconSrc = ICONPATH + \"filefail.gif\"");
					}
				}
			}else if(projectType.equals("compare")){
				if(!((CompareFile) files.get(i)).haveChanges()){
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"fileidentical.gif\"");
				}else{
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"filedifference.gif\"");
				}
			}else{
				exception.throwException(12, null, true, "");
			}

			//Add checkboxes
			javascript.add("doc"+i+".prependHTML = \"<td valign=middle><input type=checkbox id=\\\"chkbox"+i+"\\\"></td>\"");

			oldArr = pathArr;			
			
		}
	}
	
	/**
	 * This Method draws the javascript-header
	 * @param projectName
	 * @param iconPath
	 */
	public static void js_header(String projectFullNameAndVersion, String iconPath){
		javascript.add("USETEXTLINKS = 1");
		javascript.add("STARTALLOPEN = 0");
		javascript.add("USEICONS = 1");
		javascript.add("BUILDALL = 0");
		javascript.add("USEFRAMES = 0");
		javascript.add("PRESERVESTATE = 1");
		javascript.add("HIGHLIGHT = 0");
		javascript.add("ICONPATH = '"+iconPath+"'");
		javascript.add("MAX_LENGTH = "+files.size());

		javascript.add("foldersTree = gFld(\"<i>"+projectFullNameAndVersion+"</i>\", \"\")");
		javascript.add("foldersTree.treeID = \"Frameset\"");

		if(projectType.equals("normal")){
			if(failureProject){
				javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenok.gif\"");
				javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedok.gif\"");
			}else{
				javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenfail.gif\"");
				javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedfail.gif\"");
			}
		}else if(projectType.equals("compare")){
			if(failureProject){
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
			String[] xpath = null;
			try {
				String projectName = args[0];
				String globalSettings = args[1];
				
				System.out.println("\nRead needed variables...");

				folderSeparator = check.folderSeparator()+"";
				
				//Init the XMLParser
				Parser xmlParser = new Parser(globalSettings);
				
				String[] xpathWebIntProjectsPath = {"settings","global","projects","path"};
				String WebIntProjectsPath = xmlParser.read_setting(xpathWebIntProjectsPath);

				//Read the project dir
				project_settings_path = WebIntProjectsPath+check.folderSeparator()+projectName+".project";
				project_settings_xml_path = WebIntProjectsPath+check.folderSeparator()+projectName+".project.xml";
				
				Parser parser = new Parser(project_settings_xml_path);
				
				String[] xpathProjectPath = {"settings","global","project","path"};
				projectPath = parser.read_setting(xpathProjectPath);
				String[] xpathProjectName = {"settings","global","project","fullname"};
				String projectFullName = parser.read_setting(xpathProjectName);
				String[] xpathProjectVersion = {"settings","global","project","version"};
				String projectVersion = parser.read_setting(xpathProjectVersion);
				String[] xpathProjectType = {"settings","global","project","type"};
				projectType = parser.read_setting(xpathProjectType);

				//Do the work
				System.out.println("Read folder tree...");
				getAllFiles(projectName,globalSettings);

				System.out.println("Build header...");

				xpath = new String[]{"settings","website","generic","treeview","icons"};
				js_header(projectFullName+" "+projectVersion,xmlParser.read_setting(xpath));

				System.out.println("Build folder tree...");
				xpath = new String[]{"settings","global","website","defaultURI"};
				js_tree_new(projectName,xmlParser.read_setting(xpath));

				System.out.println("Save folder tree...");
				//Build the path for the javascript-path
				xpath = new String[]{"settings","website","generic","treeview","path"};
				String readedPath = xmlParser.read_setting(xpath);

				writeTxt(readedPath+folderSeparator+projectName+".js");
				System.out.println("DONE!");
			} catch (IOException e) {
				exception.throwException(1, e, true, "");
			} catch (Exception e) {
				if(xpath!=null){
					String path = "";
					for(int i=0;i<xpath.length;i++){
						path += xpath[i]+" ";
					}
					exception.throwException(2, e, true, path);
				}else{
					exception.throwException(2, e, true, "");
				}
			}

		}
	}

}
