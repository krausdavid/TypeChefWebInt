package tcwi.TCWIFile;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

public class TCWIFile {
	/**
	 * Creates an Compare-File ArrayList from an given projectfile
	 * @param errFileArr
	 * @param projectPath
	 * @return An Compare-File ArrayList
	 * @throws IOException
	 */
	public static ArrayList<TCWIFile> createTCWIFileArrayFromCompareFile(String projectPath) throws IOException{
		ArrayList<TCWIFile> fileArr = new ArrayList<TCWIFile>();
		File f = new File(projectPath);
		
		RandomAccessFile file = new RandomAccessFile(f.getAbsolutePath(),"r");
		String str = file.readLine();
		while(str!=null){
			String[] strArr = str.split("\t");
			CompareFile compareFile = new CompareFile(strArr[0],strArr[1],strArr[2],strArr[3]);
			fileArr.add(compareFile);
			str = file.readLine();
		}
		file.close();
		
		return fileArr;
	}
	
	/**
	 * Creates an Error-File ArrayList from an given projectfile
	 * @param errFileArr
	 * @param projectPath
	 * @return An Error-File ArrayList
	 * @throws IOException
	 */
//	public static ArrayList<TCWIFile> createTCWIFileArrayFromErrorFile(String projectPath) throws IOException{
//		ArrayList<TCWIFile> errFileArr = new ArrayList<TCWIFile>();
//		File f = new File(projectPath);
//		
//		RandomAccessFile file = new RandomAccessFile(f.getAbsolutePath(),"r");
//		String str = file.readLine();
//		while(str!=null){
//			String[] strArr = str.split("\t");
//			ErrorFile errFile = new ErrorFile(strArr[0],strArr[1],strArr[2],strArr[3]);
//			errFileArr.add(errFile);
//			str = file.readLine();
//		}
//		file.close();
//		
//		return errFileArr;
//	}
}
