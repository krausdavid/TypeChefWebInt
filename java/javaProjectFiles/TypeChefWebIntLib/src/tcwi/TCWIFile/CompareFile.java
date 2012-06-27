package tcwi.TCWIFile;

import java.util.ArrayList;

public class CompareFile extends TCWIFile implements Comparable<CompareFile>{

	protected String path;
	protected boolean fileExist;
	protected boolean compileError;
	protected ArrayList<ParserErrorCompare> parserError;
	protected ArrayList<TypeErrorCompare> typeError;
	
	public CompareFile(){
		this.path = "";
		parserError = new ArrayList<ParserErrorCompare>();
		typeError = new ArrayList<TypeErrorCompare>();
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

	public void addDifference(Object first, Object second){
		if(first instanceof ParserError && second instanceof ParserError){
			ParserErrorCompare e = new ParserErrorCompare((ParserError) first,(ParserError) second);
			parserError.add(e);
		}
		if(first instanceof TypeError && second instanceof TypeError){
			TypeErrorCompare e = new TypeErrorCompare((TypeError) first, (TypeError) second);
			typeError.add(e);
		}
	}
	
	public ArrayList<ParserErrorCompare> getParserErrorCompare() {
		return parserError;
	}

	public ArrayList<TypeErrorCompare> getTypeErrorCompare() {
		return typeError;
	}
	
	public int getParserErrorDiffCount(){
		int pErr = 0;
		for(int i=0;i<parserError.size();i++){
			if(parserError.get(i).haveDiff())
				pErr++;
		}
		return pErr;
	}
	
	public int getTypeErrorDiffCount(){
		int tErr = 0;
		for(int i=0;i<typeError.size();i++){
			if(typeError.get(i).haveDiff())
				tErr++;
		}
		return tErr;
	}

	public boolean haveDifferences(){
		return (getParserErrorDiffCount()+getTypeErrorDiffCount())>0 ? true : false;
	}
	
	@Override
	/**
	 * Comparing filenames
	 */
	public int compareTo(CompareFile errFile) {
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
