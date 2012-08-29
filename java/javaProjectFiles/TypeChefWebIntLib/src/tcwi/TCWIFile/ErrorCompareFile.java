package tcwi.TCWIFile;

import java.util.ArrayList;

public class ErrorCompareFile implements Comparable<ErrorFile>{

	protected String path;
	protected boolean excluded;
	protected boolean compileError;
	protected String filestate;
	protected ArrayList<ParserError> oldParserError;
	protected ArrayList<ParserError> newParserError;
	protected ArrayList<TypeError> oldTypeError;
	protected ArrayList<TypeError> newTypeError;
	
	public ErrorCompareFile(){
		this.path = "";
		oldParserError = new ArrayList<ParserError>();
		newParserError = new ArrayList<ParserError>();
		oldTypeError = new ArrayList<TypeError>();
		newTypeError = new ArrayList<TypeError>();
	}

	public void addOldError(Object error){
		if(error instanceof ParserError){
			oldParserError.add((ParserError) error);
		}
		if(error instanceof TypeError){
			oldTypeError.add((TypeError) error);
		}
	}

	public void addNewError(Object error){
		if(error instanceof ParserError){
			newParserError.add((ParserError) error);
		}
		if(error instanceof TypeError){
			newTypeError.add((TypeError) error);
		}
	}
	
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public boolean isExcluded() {
		return excluded;
	}

	public void setExcluded(boolean excluded) {
		this.excluded = excluded;
	}

	public boolean isCompileError() {
		return compileError;
	}

	public void setCompileError(boolean compileError) {
		this.compileError = compileError;
	}

	public ArrayList<ParserError> getOldParserError() {
		return oldParserError;
	}

	public ArrayList<ParserError> getNewParserError() {
		return newParserError;
	}

	public ArrayList<TypeError> getOldTypeError() {
		return oldTypeError;
	}
	public ArrayList<TypeError> getNewTypeError() {
		return newTypeError;
	}

	public boolean haveErrors(){
		return (oldParserError.size()+oldTypeError.size()+newParserError.size()+newTypeError.size())>0 ? true : false;
	}
	
	public String getFilestate() {
		return filestate;
	}

	public void setFilestate(String filestate) {
		this.filestate = filestate;
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

	@Override
	public boolean equals(Object arg0) {
		if(arg0 instanceof ErrorFile){
			return this.path.equals(((ErrorFile) arg0).getPath());
		}else{
			return false;
		}
	}
	
	
}
