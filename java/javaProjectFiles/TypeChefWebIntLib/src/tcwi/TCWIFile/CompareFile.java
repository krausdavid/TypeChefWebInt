package tcwi.TCWIFile;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

import tcwi.exception.Exceptions;

public class CompareFile extends TCWIFile implements Comparable<CompareFile>{
	protected String path;
	protected String haveNoDBG;
	protected String isEmptyFile;
	protected String isNotTrueSucceeded;
	protected String haveTypeErrors;
	
	public CompareFile(){
		this.path = "";
		this.haveNoDBG = "";
		this.isEmptyFile = "";
		this.isNotTrueSucceeded = "";
		this.haveTypeErrors = "";
	}

	public CompareFile(String path, String haveNoDBG, String isEmptyFile, String isNotTrueSucceeded, String haveTypeErrors) {
		this.path = path;
		this.haveNoDBG = haveNoDBG;
		this.isEmptyFile = isEmptyFile;
		this.isNotTrueSucceeded = isNotTrueSucceeded;
		this.haveTypeErrors = haveTypeErrors;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String isEmptyFile() {
		return isEmptyFile;
	}

	public void setEmptyFile(String isEmptyFile) {
		this.isEmptyFile = isEmptyFile;
	}

	public String isNotTrueSucceeded() {
		return isNotTrueSucceeded;
	}

	public void setNotTrueSucceeded(String isNotTrueSucceeded) {
		this.isNotTrueSucceeded = isNotTrueSucceeded;
	}

	public String isHaveTypeErrors() {
		return haveTypeErrors;
	}

	public void setHaveTypeErrors(String haveTypeErrors) {
		this.haveTypeErrors = haveTypeErrors;
	}
	
	public String isHaveNoDBG() {
		return haveNoDBG;
	}

	public void setHaveNoDBG(String haveNoDBG) {
		this.haveNoDBG = haveNoDBG;
	}
	
	/**
	 * Creates an Error-File ArrayList from an given projectfile
	 * @param errFileArr
	 * @param projectPath
	 * @return An Error-File ArrayList
	 * @throws IOException
	 */
//	public static ArrayList<CompareFile> createCompareFileArray(String projectPath) throws IOException{
//		ArrayList<CompareFile> compareFileArr = new ArrayList<CompareFile>();
//		File f = new File(projectPath);
//		
//		RandomAccessFile file = new RandomAccessFile(f.getAbsolutePath(),"r");
//		String str = file.readLine();
//		while(str!=null){
//			String[] strArr = str.split("\t");
//			CompareFile compareFile = new CompareFile(strArr[0],strArr[1],strArr[2],strArr[3],strArr[4]);
//			compareFileArr.add(compareFile);
//			str = file.readLine();
//		}
//		file.close();
//		
//		return compareFileArr;
//	}
	
	/**
	 * Check if the CompareFile have changes
	 * @return
	 */
	public boolean haveChanges(){
		String[] noDBG = this.haveNoDBG.split("|");
		String[] emptyFile = this.isEmptyFile.split("|");
		String[] notTrueSucc = this.isNotTrueSucceeded.split("|");
		String[] haveTypeErr = this.haveTypeErrors.split("|");

		if(noDBG.length >= 2 && emptyFile.length >= 2 && notTrueSucc.length >= 2 && haveTypeErr.length >= 2){
			if(!noDBG[0].equals(noDBG[1])){
				return true;
			}else{
				if(!emptyFile[0].equals(emptyFile[1])){
					return true;
				}else{
					if(!notTrueSucc[0].equals(notTrueSucc[1])){
						return true;
					}else{
						if(!haveTypeErr[0].equals(haveTypeErr[1])){
							return true;
						}else{
							return false;
						}
					}
				}
			}		
		}else{
			Exceptions exception = new Exceptions();
			exception.throwException(11, null, true, "");
			return true;
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
	public int compareTo(CompareFile compareFile) {
		if(compareFile.getPath().equals(this.path)){
			return 0;
		}
		for(int i=0;i<compareFile.getPath().length();i++){
			if(this.path.length()>i){
				if(compareFile.getPath().charAt(i)!=this.getPath().charAt(i)){
					if(compareFile.getPath().charAt(i)>this.getPath().charAt(i)){
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
}
