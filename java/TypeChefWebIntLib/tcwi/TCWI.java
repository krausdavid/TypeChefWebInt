package tcwi;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;

import tcwi.fileHandler.*;
import tcwi.xml.*;

/**
 * 
 * @author EifX
 * @version 0.0.0.4
 */
public class TCWI {
	private ArrayList<ErrorFile> files = new ArrayList<ErrorFile>();
	private Check check = new Check();
	private Parser parser;
	
	/**
	 * Get all files from an given path
	 * @param path
	 * @return
	 */
	private String getAllFiles(String path){
		File file = new File(path);
		File[] fileList = file.listFiles();
		try{
			for(int i=0;i<fileList.length;i++){
				if(fileList[i].isDirectory()){
					getAllFiles(fileList[i].getAbsolutePath());
				}else{
					if(fileList[i].toString().substring(fileList[i].toString().length()-4, fileList[i].toString().length()).equals(".dbg")){
						try{
							ErrorFile errFile = new ErrorFile(fileList[i].getAbsolutePath(),check.failFlags(fileList[i].getAbsolutePath()));
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
	
	private void writeProjectFile(String path, String projectName){
		try{
			File f = new File(path);
			f.delete();
			RandomAccessFile file = new RandomAccessFile(path+check.folderSeparator()+projectName+".project","rw");
			for(int i=0;i<files.size();i++){
				file.writeBytes(files.get(i)+"\r\n");
			}
			file.close();
		}catch (IOException e){
			System.out.println("ERROR during write the project-file at:\n"+path);
		}
	}

	private void writeProjectXMLFile(String path, String projectName){
		try{
			Calendar c = new GregorianCalendar();
			String month = (c.get(GregorianCalendar.MONTH)+1)+"";
			if(month.length()==1){
				month = "0"+month;
			}
			String day = c.get(GregorianCalendar.DAY_OF_YEAR)+"";
			if(day.length()==1){
				day = "0"+day;
			}
			String hour = c.get(GregorianCalendar.HOUR_OF_DAY)+"";
			if(hour.length()==1){
				hour = "0"+hour;
			}
			String minute = c.get(GregorianCalendar.MINUTE)+"";
			if(minute.length()==1){
				minute = "0"+minute;
			}
			String second = c.get(GregorianCalendar.SECOND)+"";
			if(second.length()==1){
				second = "0"+second;
			}
			
			System.out.println(c.get(GregorianCalendar.YEAR)+"-"+month+"-"+day);
			System.out.println(hour+":"+minute+":"+second);

			File f = new File(path);
			f.delete();
			RandomAccessFile file = new RandomAccessFile(path+check.folderSeparator()+projectName+".project.xml","rw");
			file.writeBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			file.writeBytes("<settings>");
			file.writeBytes("     <global>");
			file.writeBytes("          <project name=\""+projectName+"\" path=\""+path+"\">");
			file.writeBytes("          <init buildday=\""+c.get(GregorianCalendar.YEAR)+"-"+month+"-"+day+"\" buildtime=\""+hour+":"+minute+":"+second+"\">");
			file.writeBytes("     </global>");
			file.writeBytes("</settings>");
			file.close();
		}catch (IOException e){
			System.out.println("ERROR during write the project-file at:\n"+path);
		}
	}
	
	public void initialisize(String path, String projectName, String settingFile){
		System.out.println("Starting initialization from project "+projectName+"...");
		
		String str = getAllFiles(path);
		if(str.equals("")){
			System.out.println("Initialization DONE!");
		}else{
			System.out.println("Initialization FAILED! Maybe you do not have the rights for the path: \n"+str);
			System.exit(-1);
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
		
		parser = new Parser(settingFile);
		String[] xpath1 = {"settings","global","webint","path"};
		String[] xpath2 = {"settings","global","projects","path"};
		
		try {
			writeProjectFile(parser.read_setting(xpath1)+parser.read_setting(xpath2),projectName);
			writeProjectXMLFile(parser.read_setting(xpath1)+parser.read_setting(xpath2),projectName);
		} catch (Exception e) {
			System.out.println("ERROR by reading the settings-file.");
			System.exit(-1);
		}
		
		System.out.println("Writing DONE!\nScript DONE!");
	}
}
