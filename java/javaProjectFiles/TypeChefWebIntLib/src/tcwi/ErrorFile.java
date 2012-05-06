package tcwi;

import java.util.ArrayList;

public class ErrorFile extends TCWIFile<Boolean> implements Comparable<ErrorFile>{
		
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

	public ErrorFile(String substring, boolean[] failFlags) {
		super();
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
	
	public ArrayList<ErrorFile> convertToErrorFileArr(ArrayList<TCWIFile> tcwiFileArr){
		ArrayList<ErrorFile> errFileArr = new ArrayList<ErrorFile>();
		
		for(int i=0;i<tcwiFileArr.size();i++){
			errFileArr.add((ErrorFile) tcwiFileArr.get(i));
		}
		return errFileArr;
	}	
}
