import java.io.File;
import java.io.RandomAccessFile;
import java.util.ArrayList;

import tcwi.fileHandler.Check;
import tcwi.xml.Parser;

public class Web_WriteFileList {
	private static Check check = new Check();
	private static Parser parser;
	private static String project_settings_path;
	private static String project_settings_xml_path;
	private static String project_settings_lst_path;

	private static final String VERSION = "0.0.0.1";
	private static final String AUTHORS = "EifX & hulllemann";
	
	public static void main(String args[]){
		if(args.length!=2){
			System.out.println("Help - web_WriteFileList "+VERSION+" by "+AUTHORS);
			System.out.println("----------------------------------------------------");
			System.out.println("\nUsage: web_WriteFileList [PROJECTNAME] [CHECKBOX_STRING]");
			System.out.println("\n[PROJECTNAME]");
			System.out.println("\n     Project name\n");
			System.out.println("\n[CHECKBOX_STRING]");
			System.out.println("\n     The checkbox string from the website");
		}else{
			//Read the project dir
			File f = new File("");
			String path = f.getAbsolutePath();
			path = path.substring(0,path.lastIndexOf(check.folderSeparator()+""));
			path = path.substring(0,path.lastIndexOf(check.folderSeparator()+""));
			path = path+check.folderSeparator()+"projects"+check.folderSeparator();
			project_settings_path = path+args[0]+".project";
			project_settings_xml_path = path+args[0]+".project.xml";
			project_settings_lst_path = path+args[0]+".lst";
	
			args[1] = args[1].substring(0,args[1].length()-1);
			String[] strArr = args[1].split("_");

			int[] intArr = new int[strArr.length];
			
			for(int i=0;i<strArr.length;i++){
				intArr[i] = Integer.valueOf(strArr[i].substring(6));
			}

			RandomAccessFile file;
			ArrayList<String> writeInFile = new ArrayList<String>();
			int j = 0;
			int i = 0;
			
			try {
				parser = new Parser(project_settings_xml_path);
				String[] xpath = {"settings","global","project","path"};
				String projectPath = parser.read_setting(xpath);

				file = new RandomAccessFile(project_settings_path,"r");
				
				String str = file.readLine();
				while(str!=null){
					if(intArr[i]==j){
						String[] tmpArr = str.split("\t");
						writeInFile.add(tmpArr[0].substring(projectPath.length()+1,tmpArr[0].length()-4));
						str = file.readLine();
						i++;
					}
					if(i>=intArr.length){
						break;
					}
					j++;
				}
				file.close();
		
				f = new File(project_settings_lst_path);
				f.delete();
				file = new RandomAccessFile(project_settings_lst_path,"rw");
				for(int k=0;k<writeInFile.size();k++){
					file.writeBytes(writeInFile.get(k)+"\r\n");
				}
				file.close();
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
