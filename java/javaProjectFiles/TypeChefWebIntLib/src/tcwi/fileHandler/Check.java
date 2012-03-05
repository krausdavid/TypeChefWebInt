package tcwi.fileHandler;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

public class Check {
	
	public boolean hasNoDBG(String path){
		File f = new File(path+".dbg");
		return !f.exists();
	}
	
	/**
	 * Returns for a file <tt>true</tt> or <tt>false</tt> if TypeChef said "True succeeded" or not
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public String ifTrueSucc(String path) throws IOException{
		if(!hasNoDBG(path)){
			RandomAccessFile file = new RandomAccessFile(path+".dbg","r");
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
		}else{
			return "FAIL";
		}
	}
	
	/**
	 * Check if a given file is empty
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public boolean isEmpty(String path) throws IOException{
		if(!hasNoDBG(path)){
			RandomAccessFile file = new RandomAccessFile(path+".dbg","r");
			if(file.length()==0){
				file.close();
				return true;
			}else{
				file.close();
				return false;
			}
		}else{
			return true;
		}
	}

	/**
	 * Returns for a file <tt>true</tt> or <tt>false</tt> if TypeChef said "No type errors found." or not
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public String ifNoTypeError(String path) throws IOException{
		if(!hasNoDBG(path)){
			RandomAccessFile file = new RandomAccessFile(path+".dbg","r");
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
		}else{
			return "FAIL";
		}
	}
	
	/**
	 * Test a given file if it is a failure file
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public boolean isNotAFailFile(String path) throws IOException{
		boolean[] flags = failFlags(path);
		if(flags[0]==false){
			return !flags[1]&&!flags[2]&&!flags[3];
		}else{
			return false;
		}
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
		if(!hasNoDBG(path)){
			RandomAccessFile file = new RandomAccessFile(path+".dbg","r");
			boolean[] flags = {false,true,true,true};

			if(file.length()!=0){
				flags[1] = false;
			}
			
			String str = file.readLine();
			while(str!=null){
				if(str.contains("True\tsucceeded")){
					flags[2] = false;
				}
				if(str.contains("No type errors found.")){
					flags[3] = false;
					break;
				}
				str = file.readLine();
			}
	
			file.close();

			return flags;
		}else{
			boolean[] flags = {true,true,true,true};
			return flags;
		}
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
