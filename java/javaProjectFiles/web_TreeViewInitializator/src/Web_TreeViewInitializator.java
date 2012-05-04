import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

import tcwi.xml.*;
import tcwi.fileHandler.*;
import tcwi.ErrorFile;

public class Web_TreeViewInitializator {

	private static final String VERSION = "0.1.3.4";
	private static final String AUTHORS = "EifX & hulllemann";
	private static ArrayList<String> javascript = new ArrayList<String>();
	private static ArrayList<ErrorFile> files = new ArrayList<ErrorFile>();
	private static String folderSeparator;
	private static Check check = new Check();
	private static boolean failureProject = false;
	private static String projectPath;
	private static String project_settings_path;
	private static String project_settings_xml_path;
	
	/**
	 * Read the file-list generated by web_ProjectInitializator
	 * @param projectName
	 * @param settingsFile
	 */
	public static void getAllFiles(String projectName, String settingsFile){
		RandomAccessFile file = null;
		try{
			File f = new File(project_settings_path);
			
			//If the project have minimal one error, the main-folder in the tree-list is a fail folder
			Parser projectParser = new Parser(project_settings_xml_path);

			String[] xpathProject = {"settings","global","projects","failureProject"};
			if(projectParser.read_setting(xpathProject).equals("true")){
				failureProject = true;
			}else{
				failureProject = false;
			}
			
			
			files.clear();
			
			file = new RandomAccessFile(f.getAbsolutePath(),"r");
			String str = file.readLine();
			while(str!=null){
				String[] strArr = str.split("\t");
				ErrorFile errFile = new ErrorFile(strArr[0],strArr[1],strArr[2],strArr[3],strArr[4]);
				files.add(errFile);
				str = file.readLine();
			}
			file.close();
		}catch(Exception e){
			System.out.println("ERROR: Can't read the setting file");
			e.printStackTrace();
			System.exit(-1);
		}
	}
	
	/**
	 * Check a given folder for failure dbg-files.
	 * @param path
	 * @return
	 */
	public static boolean isAFailFolder(String path){
		ArrayList<ErrorFile> filesNew = new ArrayList<ErrorFile>();
		for(int i=0;i<files.size();i++){
			if(files.get(i).getPath().contains(path)){
				filesNew.add(files.get(i));
			}
		}
		for(int i=0;i<filesNew.size();i++){
			if(filesNew.get(i).haveErrors()){
				return true;
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
			System.out.println("ERROR! Javascript write error in path : "+path);
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
			relativeFiles.add(files.get(i).getPath().substring(projectPath.length()+1));
		}
		
		String[] oldArr = {""};
		
		for(int i=0;i<relativeFiles.size();i++){
			int notEqual = -1;
			String newPath = relativeFiles.get(i);
			
			String[] pathArr;
			if(folderSeparator.equals("\\")){
				pathArr = relativeFiles.get(i).split(folderSeparator+folderSeparator);
			}else{
				pathArr = relativeFiles.get(i).split(folderSeparator);
			}

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
						javascript.add(cleanStr("var "+pathArr[0])+" = insFld(foldersTree, gFld(\""+pathArr[0]+"\", \"\"))");
					}else{
						javascript.add(cleanStr(pathArr[j])+" = insFld("+cleanStr(pathArr[j-1])+", gFld(\""+pathArr[j]+"\", \"\"))");
					}
					//Draw foldericons
					String p = "";
					for(int k=0;k<=j;k++){
						p+=folderSeparator+pathArr[k];
					}
					p = projectPath+p;
					if(!isAFailFolder(p)){
						javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \"folderopenok.gif\"");
						javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \"folderclosedok.gif\"");
					}else{
						javascript.add(cleanStr(pathArr[j])+".iconSrc = ICONPATH + \"folderopenfail.gif\"");
						javascript.add(cleanStr(pathArr[j])+".iconSrcClosed = ICONPATH + \"folderclosedfail.gif\"");
					}
				}
			}
			
			newPath = newPath.replace("\\", "/");
			newPath = newPath.replace(" ", "_");

			//Print the files!
			if(pathArr.length==1){
				javascript.add("var doc"+i+" = insDoc(foldersTree, gLnk(\"S\", \""+pathArr[pathArr.length-1]+"\", \""+defaultURI+"/project?choice=view&files="+newPath+"&project="+projectName+"\"))");
			}else{
				javascript.add("doc"+i+" = insDoc("+cleanStr(pathArr[pathArr.length-2])+", gLnk(\"S\", \""+pathArr[pathArr.length-1]+"\", \""+defaultURI+"/project?choice=view&files="+newPath+"&project="+projectName+"\"))");
			}

			//Draw fileicons
			if(!files.get(i).haveErrors()){
				javascript.add("doc"+i+".iconSrc = ICONPATH + \"fileok.gif\"");
			}else{
				if(files.get(i).isHaveNoDBG()){
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"fileempty.gif\"");
				}else{
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"filefail.gif\"");
				}
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

		if(failureProject){
			javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenok.gif\"");
			javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedok.gif\"");
		}else{
			javascript.add("foldersTree.iconSrc = ICONPATH + \"folderopenfail.gif\"");
			javascript.add("foldersTree.iconSrcClosed = ICONPATH + \"folderclosedfail.gif\"");
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
			try {
				System.out.println("\nRead needed variables...");

				folderSeparator = check.folderSeparator()+"";
				
				//Init the XMLParser
				Parser xmlParser = new Parser(args[1]);
				
				String[] xpathWebIntProjectsPath = {"settings","global","projects","path"};
				String WebIntProjectsPath = xmlParser.read_setting(xpathWebIntProjectsPath);

				//Read the project dir
				project_settings_path = WebIntProjectsPath+check.folderSeparator()+args[0]+".project";
				project_settings_xml_path = WebIntProjectsPath+check.folderSeparator()+args[0]+".project.xml";
				
				Parser parser = new Parser(project_settings_xml_path);
				
				String[] xpathProjectPath = {"settings","global","project","path"};
				projectPath = parser.read_setting(xpathProjectPath);
				String[] xpathProjectName = {"settings","global","project","fullname"};
				String projectFullName = parser.read_setting(xpathProjectName);
				String[] xpathProjectVersion = {"settings","global","project","version"};
				String projectVersion = parser.read_setting(xpathProjectVersion);
				

				//Do the work
				System.out.println("Read folder tree...");
				getAllFiles(args[0],args[1]);

				System.out.println("Build header...");

				String[] xpath = {"settings","website","generic","treeview","icons"};
				js_header(projectFullName+" "+projectVersion,xmlParser.read_setting(xpath));

				System.out.println("Build folder tree...");
				xpath = new String[]{"settings","global","website","defaultURI"};
				js_tree_new(args[0],xmlParser.read_setting(xpath));

				System.out.println("Save folder tree...");
				//Build the path for the javascript-path
				xpath = new String[]{"settings","website","generic","treeview","path"};
				String readedPath = xmlParser.read_setting(xpath);

				writeTxt(readedPath+folderSeparator+args[0]+".js");
				System.out.println("DONE!");
			} catch (Exception e) {
				System.out.println("ERROR! File not exists, read error or XML not well-formed!\n\n");
				e.printStackTrace();
			}

		}
	}

}
