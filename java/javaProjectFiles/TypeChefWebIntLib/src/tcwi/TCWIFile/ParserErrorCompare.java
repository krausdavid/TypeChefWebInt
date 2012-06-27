package tcwi.TCWIFile;

public class ParserErrorCompare {
	private ParserError file1;
	private ParserError file2;
	
	public ParserErrorCompare(ParserError file1, ParserError file2){
		this.file1 = file1;
		this.file2 = file2;
	}
	
	public boolean haveDiffFeaturestr(){
		return file1.getFeaturestr().equals(file2.getFeaturestr()) ? true : false;
	}
	public boolean haveDiffMsg(){
		return file1.getMsg().equals(file2.getMsg()) ? false : true;
	}
	public boolean haveDiffFile(){
		return file1.getFile().equals(file2.getFile()) ? false : true;
	}
	public boolean haveDiffLine(){
		return file1.getLine().equals(file2.getLine()) ? false : true;
	}
	public boolean haveDiffCol(){
		return file1.getCol().equals(file2.getCol()) ? false : true;
	}

	public boolean haveDiff(){
		return (haveDiffFeaturestr()&&haveDiffMsg()&&haveDiffFile()&&haveDiffLine()&&haveDiffCol())==false ? false : true;
	}

	public ParserError getFile1() {
		return file1;
	}

	public ParserError getFile2() {
		return file2;
	}
	
}
