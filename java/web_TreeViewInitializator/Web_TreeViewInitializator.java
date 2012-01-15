import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

import tcwi.xml.*;
import tcwi.fileHandler.*;
import tcwi.ErrorFile;

public class Web_TreeViewInitializator {

	private static final String VERSION = "0.0.3.0";
	private static final String AUTHORS = "EifX & hulllemann";
	private static ArrayList<String> javascript = new ArrayList<String>();
	private static ArrayList<ErrorFile> files = new ArrayList<ErrorFile>();
	private static String folderSeparator;
	private static Check check = new Check();
	private static Parser parser;
	private static boolean failureProject = false;
	
	public static void getAllFiles(String projectName, String settingsFile){
		RandomAccessFile file = null;
		try{
			File f = new File("");
			String path = f.getAbsolutePath();
			path = path.substring(0,path.lastIndexOf(check.folderSeparator()));
			path = path.substring(0,path.lastIndexOf(check.folderSeparator()));
			parser = new Parser(settingsFile);
			String[] xpath = {"settings","global","projects","path"};
			
			f = new File(path+parser.read_setting(xpath)+check.folderSeparator()+projectName+".project");
			
			//If the project have minimal one error, the main-folder in the tree-list is a fail folder
			Parser projectParser = new Parser(path+parser.read_setting(xpath)+check.folderSeparator()+projectName+".project.xml");
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
				ErrorFile errFile = new ErrorFile(strArr[0],strArr[1],strArr[2],strArr[3]);
				files.add(errFile);
				str = file.readLine();
			}
			file.close();
		}catch(Exception e){
			System.out.println("ERROR: Can't read the setting file");
			try {
				file.close();
			} catch (IOException e1) {}
			System.exit(-1);
		}
	}
	
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
	 * Get all files from an given path. If failureTest is set, this method said, if an path have an error file
	 * @param path
	 * @param failureTest
	 * @return
	 */
/*	public static boolean getAllFiles(String path, boolean failureTest){
		File file = new File(path);
		File[] fileList = file.listFiles();
		try{
			for(int i=0;i<fileList.length;i++){
				//If it is a Dir, go deeper
				if(fileList[i].isDirectory()){
					if(!getAllFiles(fileList[i].getAbsolutePath(),failureTest)){
						return false;
					}
				}else{
					//If it is a File, write it down!
					if(fileList[i].toString().substring(fileList[i].toString().length()-4, fileList[i].toString().length()).equals(".dbg")){
						if(fileList[i].canRead()){
							if(failureTest){
								try {
									if(!(check.isNotAFailFile(fileList[i].getAbsolutePath()))){
										return false;
									}
								} catch (IOException e) {
									System.out.println("ERROR! DBG-File read error : "+files.get(i).getPath());
									System.exit(-1);
								}
							}else{
								files.add(fileList[i]);
							}
						}
					}
				}
			}
		}catch (Exception e){
			System.out.println("ERROR! Wrong path or not enough rights to view it!");
			System.exit(-1);
		}
		return true;
	}
*/
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
		return newStr;
	}

	/**
	 * This Method create the javascript-path
	 * @param path
	 */
	public static void js_tree(String path, String projectName, String defaultURI){
		String[] oldArr = {""};
		int notEqual = -1;
		
		for(int i=0;i<files.size();i++){
			//Get the file
			notEqual = -1;
			String newPath = files.get(i).getPath().substring(path.length()+1);

			String[] pathArr;
			if(folderSeparator=="\\"){
				pathArr = newPath.split(folderSeparator+folderSeparator);
			}else{
				pathArr = newPath.split(folderSeparator);
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

			//If a file is exist, do nothing
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
					p = path+p;
					if(isAFailFolder(p)){
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
				javascript.add("doc"+i+" = insDoc(foldersTree, gLnk(\"S\", \""+pathArr[pathArr.length-1]+"\", \""+defaultURI+"/?files="+newPath+"&project="+projectName+"\"))");
			}else{
				javascript.add("doc"+i+" = insDoc("+cleanStr(pathArr[pathArr.length-2])+", gLnk(\"S\", \""+pathArr[pathArr.length-1]+"\", \""+defaultURI+"/?files="+newPath+"&project="+projectName+"\"))");
			}

			//Draw fileicons
			try {
				if(check.isNotAFailFile(files.get(i).getPath())){
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"fileok.gif\"");
				}else{
					javascript.add("doc"+i+".iconSrc = ICONPATH + \"filefail.gif\"");
				}
			} catch (IOException e) {
				System.out.println("ERROR! DBG-File read error : "+files.get(i).getPath());
				System.exit(-1);
			}
			//Add checkboxes
			javascript.add("doc"+i+".prependHTML = \"<td valign=middle><input type=checkbox id=\"+"+i+"+\"></td>\"");

			oldArr = pathArr;

		}
	}

	/**
	 * This Method draws the javascript-header
	 * @param projectName
	 * @param iconPath
	 */
	public static void js_header(String projectName, String iconPath, String projectPath){
		javascript.add("USETEXTLINKS = 1");
		javascript.add("STARTALLOPEN = 0");
		javascript.add("USEICONS = 1");
		javascript.add("BUILDALL = 1");
		javascript.add("ICONPATH = '"+iconPath+"'");

		javascript.add("foldersTree = gFld(\"<i>"+projectName+"</i>\", \"\")");
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
			System.out.println("\nUsage: web_TreeViewInitializator [PATH] [PROJECTNAME] [GLOBAL_SETTINGS]");
			System.out.println("\n[PROJECTNAME]");
			System.out.println("\n     Project name\n");
			System.out.println("\n[GLOBAL_SETTINGS]");
			System.out.println("\n     Absolute Path for the global_settings.xml\n     (include the name of the settings file)\n");
		}else{
			try {
				System.out.println("\nRead needed variables...");
				
				//Windows or Unix OS?
				folderSeparator = check.folderSeparator()+"";
				
				//Init the XMLParser
				Parser xmlParser = new Parser(args[1]);

				System.out.println("Read folder tree...");
				getAllFiles(args[0],args[1]);

//TODO:

				System.out.println("Build header...");

				String[] xpath = {"settings","website","generic","treeview","icons"};
				js_header(args[1],xmlParser.read_setting(xpath),args[0]);

				System.out.println("Build folder tree...");
				xpath = new String[]{"settings","global","website","defaultURI"};
				js_tree(args[0],args[1],xmlParser.read_setting(xpath));

				System.out.println("\nSave folder tree...");
				xpath = new String[]{"settings","global","webint","path"};
				String readedPath = xmlParser.read_setting(xpath);
				xpath = new String[]{"settings","global","website","path"};
				readedPath = readedPath+xmlParser.read_setting(xpath);
				xpath = new String[]{"settings","website","generic","treeview","path"};
				readedPath = readedPath+xmlParser.read_setting(xpath);

				writeTxt(readedPath+folderSeparator+args[1]+".js");
				System.out.println("DONE!");


			} catch (Exception e) {
				System.out.println("ERROR! File not exists, read error or XML not well-formed!\n\n");
				e.printStackTrace();
			}

		}
	}

}
