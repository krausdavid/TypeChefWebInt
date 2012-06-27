package tcwi.TCWIFile;

import java.util.ArrayList;

public class ErrorFile extends TCWIFile implements Comparable<ErrorFile>{

	protected String path;
	protected boolean fileExist;
	protected boolean compileError;
	protected ArrayList<ParserError> parserError;
	protected ArrayList<TypeError> typeError;
	
	public ErrorFile(){
		this.path = "";
		parserError = new ArrayList<ParserError>();
		typeError = new ArrayList<TypeError>();
	}
	
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public boolean isFileExist() {
		return fileExist;
	}

	public void setFileExist(boolean fileExist) {
		this.fileExist = fileExist;
	}

	public boolean isCompileError() {
		return compileError;
	}

	public void setCompileError(boolean compileError) {
		this.compileError = compileError;
	}

	public void addError(Object error){
		if(error instanceof ParserError){
			parserError.add((ParserError) error);
		}
		if(error instanceof TypeError){
			typeError.add((TypeError) error);
		}
	}
	
	public ArrayList<ParserError> getParserError() {
		return parserError;
	}

	public ArrayList<TypeError> getTypeError() {
		return typeError;
	}

	public boolean haveErrors(){
		return (parserError.size()+typeError.size())>0 ? true : false;
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
