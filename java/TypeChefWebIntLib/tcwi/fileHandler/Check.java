package tcwi.fileHandler;

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
		RandomAccessFile file = new RandomAccessFile(path,"r");
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
		return false;
	}
}
