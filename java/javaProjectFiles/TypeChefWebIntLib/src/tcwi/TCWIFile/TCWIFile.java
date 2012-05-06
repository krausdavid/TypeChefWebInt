package tcwi.TCWIFile;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;

public class TCWIFile<T> {
	protected String path;
	protected T haveNoDBG;
	protected T isEmptyFile;
	protected T isNotTrueSucceeded;
	protected T haveTypeErrors;
	
	@SuppressWarnings({ "unchecked", "static-access" })
	public TCWIFile(){
		this.path = "";
		T t = null;
		if(t instanceof Boolean){
			Boolean b = null;
			this.haveNoDBG = (T) ((Boolean) b).TRUE;
			this.isEmptyFile = (T) ((Boolean) b).TRUE;
			this.isNotTrueSucceeded = (T) ((Boolean) b).TRUE;
			this.haveTypeErrors = (T) ((Boolean) b).TRUE;
		}else if(t instanceof String){
			String s = "";
			this.haveNoDBG = (T) ((String) s).valueOf(s);
			this.isEmptyFile = (T) ((String) s).valueOf(s);
			this.isNotTrueSucceeded = (T) ((String) s).valueOf(s);
			this.haveTypeErrors = (T) ((String) s).valueOf(s);
		}else{
			this.haveNoDBG = null;
			this.isEmptyFile = null;
			this.isNotTrueSucceeded = null;
			this.haveTypeErrors = null;
		}
	}

	public TCWIFile(String path, T haveNoDBG, T isEmptyFile, T isNotTrueSucceeded, T haveTypeErrors) {
		this.path = path;
		this.haveNoDBG = haveNoDBG;
		this.isEmptyFile = isEmptyFile;
		this.isNotTrueSucceeded = isNotTrueSucceeded;
		this.haveTypeErrors = haveTypeErrors;
	}

	@SuppressWarnings({ "unchecked", "static-access" })
	public TCWIFile(String path, boolean[] flags) {
		this.path = path;
		T t = null;
		if(t instanceof Boolean){
			Boolean b = null;
			this.haveNoDBG = (T) ((Boolean) b).valueOf(flags[0]);
			this.isEmptyFile = (T) ((Boolean) b).valueOf(flags[1]);
			this.isNotTrueSucceeded = (T) ((Boolean) b).valueOf(flags[2]);
			this.haveTypeErrors = (T) ((Boolean) b).valueOf(flags[3]);
		}
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public T isEmptyFile() {
		return isEmptyFile;
	}

	public void setEmptyFile(T isEmptyFile) {
		this.isEmptyFile = isEmptyFile;
	}

	public T isNotTrueSucceeded() {
		return isNotTrueSucceeded;
	}

	public void setNotTrueSucceeded(T isNotTrueSucceeded) {
		this.isNotTrueSucceeded = isNotTrueSucceeded;
	}

	public T isHaveTypeErrors() {
		return haveTypeErrors;
	}

	public void setHaveTypeErrors(T haveTypeErrors) {
		this.haveTypeErrors = haveTypeErrors;
	}
	
	public T isHaveNoDBG() {
		return haveNoDBG;
	}

	public void setHaveNoDBG(T haveNoDBG) {
		this.haveNoDBG = haveNoDBG;
	}
	
	/**
	 * Creates an Error-File ArrayList from an given projectfile
	 * @param errFileArr
	 * @param projectPath
	 * @return An Error-File ArrayList
	 * @throws IOException
	 */
	public static ArrayList<TCWIFile> createTCWIFileArray(String projectPath) throws IOException{
		ArrayList<TCWIFile> tcwiFileArr = new ArrayList<TCWIFile>();
		File f = new File(projectPath);
		
		RandomAccessFile file = new RandomAccessFile(f.getAbsolutePath(),"r");
		String str = file.readLine();
		while(str!=null){
			String[] strArr = str.split("\t");
			TCWIFile<String> tcwiFile = new TCWIFile<String>();
			tcwiFile.setPath(strArr[0]);
			tcwiFile.setHaveNoDBG(strArr[1]);
			tcwiFile.setEmptyFile(strArr[2]);
			tcwiFile.setNotTrueSucceeded(strArr[3]);
			tcwiFile.setHaveTypeErrors(strArr[4]);
			
			tcwiFileArr.add(tcwiFile);
			str = file.readLine();
		}
		file.close();
		
		return tcwiFileArr;
	}
	
}
