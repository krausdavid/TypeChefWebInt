package tcwi;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

public class ErrorFile implements Comparable<ErrorFile>{
	private String path;
	private boolean haveNoDBG;
	private boolean isEmptyFile;
	private boolean isNotTrueSucceeded;
	private boolean haveTypeErrors;
	
	public ErrorFile(){
		this.path = "";
		this.haveNoDBG = true;
		this.isEmptyFile = true;
		this.isNotTrueSucceeded = true;
		this.haveTypeErrors = true;
	}

	public ErrorFile(String path, boolean haveNoDBG, boolean isEmptyFile, boolean isNotTrueSucceeded, boolean haveTypeErrors) {
		this.path = path;
		this.haveNoDBG = haveNoDBG;
		this.isEmptyFile = isEmptyFile;
		this.isNotTrueSucceeded = isNotTrueSucceeded;
		this.haveTypeErrors = haveTypeErrors;
	}
	
	public ErrorFile(String path,String haveNoDBG, String isEmptyFile, String isNotTrueSucceeded, String haveTypeErrors) {
		this.path = path;
		if(haveNoDBG.equals("true")){
			this.haveNoDBG = true;
		}else{
			this.haveNoDBG = false;
		}
		if(isEmptyFile.equals("true")){
			this.isEmptyFile = true;
		}else{
			this.isEmptyFile = false;
		}
		if(isNotTrueSucceeded.equals("true")){
			this.isNotTrueSucceeded = true;
		}else{
			this.isNotTrueSucceeded = false;
		}
		if(haveTypeErrors.equals("true")){
			this.haveTypeErrors = true;
		}else{
			this.haveTypeErrors = false;
		}
	}

	public ErrorFile(String path, boolean[] flags) {
		this.path = path;
		this.haveNoDBG = flags[0];
		this.isEmptyFile = flags[1];
		this.isNotTrueSucceeded = flags[2];
		this.haveTypeErrors = flags[3];
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public boolean isEmptyFile() {
		return isEmptyFile;
	}

	public void setEmptyFile(boolean isEmptyFile) {
		this.isEmptyFile = isEmptyFile;
	}

	public boolean isNotTrueSucceeded() {
		return isNotTrueSucceeded;
	}

	public void setNotTrueSucceeded(boolean isNotTrueSucceeded) {
		this.isNotTrueSucceeded = isNotTrueSucceeded;
	}

	public boolean isHaveTypeErrors() {
		return haveTypeErrors;
	}

	public void setHaveTypeErrors(boolean haveTypeErrors) {
		this.haveTypeErrors = haveTypeErrors;
	}
	
	public boolean isHaveNoDBG() {
		return haveNoDBG;
	}

	public void setHaveNoDBG(boolean haveNoDBG) {
		this.haveNoDBG = haveNoDBG;
	}

	public boolean haveErrors(){
		if(this.haveNoDBG){
			return true;
		}else{
			if(this.isEmptyFile){
				return true;
			}else{
				if(this.isNotTrueSucceeded){
					return true;
				}else{
					if(this.haveTypeErrors){
						return true;
					}else{
						return false;
					}
				}
			}
		}
	}

	@Override
	public String toString() {
		return this.path+"\t"+haveNoDBG+"\t"+isEmptyFile+"\t"+isNotTrueSucceeded+"\t"+haveTypeErrors;
	}

	@Override
	/**
	 * Comparing filenames
	 */
	public int compareTo(ErrorFile errFile) {
		if(errFile.getPath().equals(this.path)){
			return 0;
		}
		for(int i=0;i<errFile.getPath().length();i++){
			if(this.path.length()>i){
				if(errFile.getPath().charAt(i)!=this.getPath().charAt(i)){
					if(errFile.getPath().charAt(i)>this.getPath().charAt(i)){
						return -1;
					}else{
						return 1;
					}
				}
			}else{
				return 1;
			}
		}
		
		return 0;
	}
	
	/**
	 * Creates an Error-File ArrayList from an given projectfile
	 * @param errFileArr
	 * @param projectPath
	 * @return An Error-File ArrayList
	 * @throws IOException
	 */
	public ArrayList<ErrorFile> createErrorFileArray(ArrayList<ErrorFile> errFileArr, String projectPath) throws IOException{
		File f = new File(projectPath);
		errFileArr.clear();
		
		RandomAccessFile file = new RandomAccessFile(f.getAbsolutePath(),"r");
		String str = file.readLine();
		while(str!=null){
			String[] strArr = str.split("\t");
			ErrorFile errFile = new ErrorFile(strArr[0],strArr[1],strArr[2],strArr[3],strArr[4]);
			errFileArr.add(errFile);
			str = file.readLine();
		}
		file.close();
		
		return errFileArr;
	}
	
}
