package tcwi.TCWIFile;

public class ErrorFile extends TCWIFile implements Comparable<ErrorFile>{

	protected String path;
	protected boolean haveNoDBG;
	protected boolean isNotTrueSucceeded;
	protected boolean haveTypeErrors;
	
	public ErrorFile(){
		this.path = "";
		this.haveNoDBG = true;
		this.isNotTrueSucceeded = true;
		this.haveTypeErrors = true;
	}

	public ErrorFile(String path, boolean haveNoDBG, boolean isNotTrueSucceeded, boolean haveTypeErrors) {
		this.path = path;
		this.haveNoDBG = haveNoDBG;
		this.isNotTrueSucceeded = isNotTrueSucceeded;
		this.haveTypeErrors = haveTypeErrors;
	}

	public ErrorFile(String path, boolean[] flags) {
		this.path = path;
		this.haveNoDBG = flags[0];
		this.isNotTrueSucceeded = flags[1];
		this.haveTypeErrors = flags[2];
	}
	
	public ErrorFile(String path,String haveNoDBG, String isNotTrueSucceeded, String haveTypeErrors) {
		this.path = path;
		if(haveNoDBG.equals("true")){
			this.haveNoDBG = true;
		}else{
			this.haveNoDBG = false;
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

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
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

	@Override
	public String toString() {
		return this.path+"\t"+haveNoDBG+"\t"+isNotTrueSucceeded+"\t"+haveTypeErrors;
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
}
