package tcwi.fileHandler;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

public class Check {
	
	/**
	 * Returns for a file <tt>true</tt> or <tt>false</tt> if TypeChef said "True succeeded" or not
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public String ifTrueSucc(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		String str = file.readLine();
		while(str!=null){
			if(str.contains("True\tsucceeded")){
				file.close();
				return " OK ";
			}
			str = file.readLine();
		}
		file.close();
		return "FAIL";
	}
	
	/**
	 * Check if a given file is empty
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public boolean isEmpty(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		if(file.length()==0){
			file.close();
			return true;
		}else{
			file.close();
			return false;
		}
	}

	/**
	 * Returns for a file <tt>true</tt> or <tt>false</tt> if TypeChef said "No type errors found." or not
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public String ifNoTypeError(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		String str = file.readLine();
		while(str!=null){
			if(str.contains("No type errors found.")){
				file.close();
				return " OK ";
			}
			str = file.readLine();
		}
		file.close();
		return "FAIL";
	}
	
	/**
	 * Test a given file if it is a failure file
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public boolean isNotAFailFile(String path) throws IOException{
/*		RandomAccessFile file = new RandomAccessFile(path,"r");
		if(file.length()==0){
			file.close();
			return false;
		}

		String str = file.readLine();
		boolean trueSucc = false;
		while(str!=null){
			if(str.contains("True\tsucceeded")){
				trueSucc = true;
			}
			if(str.contains("No type errors found.")&&trueSucc){
				file.close();
				return true;
			}
			str = file.readLine();
		}

		file.close();
		return false;*/
		boolean[] flags = failFlags(path);
		return !flags[0]&&!flags[1]&&!flags[2];
	}
	
	/**
	 * Return a failure-flag-array from a given File<br>
	 * The failure-flag-array has the following 3 boolean flags:<br><br>
	 * [0] = Is an empty file?<br>
	 * [1] = Is not an true succeeded file?<br>
	 * [2] = Type-errors?<br>
	 * @param path
	 * @return 3 boolean-flags as an array
	 * @throws IOException
	 */
	public boolean[] failFlags(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		boolean[] flags = {true,true,true};
		
		if(file.length()!=0){
			flags[0] = false;
		}

		String str = file.readLine();
		while(str!=null){
			if(str.contains("True\tsucceeded")){
				flags[1] = false;
			}
			if(str.contains("No type errors found.")){
				flags[2] = false;
			}
			str = file.readLine();
		}

		file.close();
		return flags;
	}
	
	/**
	 * This method returns the OS typical folder separator
	 * @return The separator
	 */
	public char folderSeparator(){
		File f = new File("");
		if(f.getAbsolutePath().charAt(0)=='/'){
			return '/';
		}else{
			return '\\';
		}
		
	}
}
