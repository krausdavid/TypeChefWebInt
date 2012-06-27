package tcwi.TCWIFile;

public class TypeErrorCompare {
	private TypeError file1;
	private TypeError file2;
	
	public TypeErrorCompare(TypeError file1, TypeError file2){
		this.file1 = file1;
		this.file2 = file2;
	}
	
	public boolean haveDiffFeaturestr(){
		return file1.getFeaturestr().equals(file2.getFeaturestr()) ? true : false;
	}
	public boolean haveDiffMsg(){
		return file1.getMsg().equals(file2.getMsg()) ? false : true;
	}
	public boolean haveDiffSeverity(){
		return file1.getSeverity().equals(file2.getSeverity()) ? false : true;
	}
	public boolean haveDiffFromFile(){
		return file1.getFromFile().equals(file2.getFromFile()) ? false : true;
	}
	public boolean haveDiffFromLine(){
		return file1.getFromLine().equals(file2.getFromLine()) ? false : true;
	}
	public boolean haveDiffFromCol(){
		return file1.getFromCol().equals(file2.getFromCol()) ? false : true;
	}
	public boolean haveDiffToFile(){
		return file1.getToFile().equals(file2.getToFile()) ? false : true;
	}
	public boolean haveDiffToLine(){
		return file1.getToLine().equals(file2.getToLine()) ? false : true;
	}
	public boolean haveDiffToCol(){
		return file1.getToCol().equals(file2.getToCol()) ? false : true;
	}
	
	public boolean haveDiff(){
		return (haveDiffFeaturestr()&&haveDiffMsg()&&haveDiffSeverity()&&haveDiffFromFile()&&haveDiffFromLine()&&haveDiffFromCol()&&haveDiffToFile()&&haveDiffToLine()&&haveDiffToCol())==false ? false : true;
	}

	public TypeError getFile1() {
		return file1;
	}

	public TypeError getFile2() {
		return file2;
	}
	
}
