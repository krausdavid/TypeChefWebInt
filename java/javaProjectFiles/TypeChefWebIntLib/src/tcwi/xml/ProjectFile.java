package tcwi.xml;

import java.util.ArrayList;

import tcwi.TCWIFile.ErrorFile;

public class ProjectFile extends MasterFile{

	private String version;
	private String isDelta;
	private String mainproject;
	private ArrayList<ErrorFile> files;

	public ProjectFile(){
		this.version="";
		this.isDelta="";
		this.mainproject="";
		this.files = new ArrayList<ErrorFile>();
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getIsDelta() {
		return isDelta;
	}

	public void setIsDelta(String hasDeltas) {
		this.isDelta = hasDeltas;
	}

	public String getMainproject() {
		return mainproject;
	}

	public void setMainproject(String mainproject) {
		this.mainproject = mainproject;
	}

	public ArrayList<ErrorFile> getFiles() {
		return files;
	}

	public void addFile(ErrorFile file) {
		this.files.add(file);
	}

	public boolean haveErrors(){
		return (!parsererrors.equals("0")||!typeerrors.equals("0")||!compileerrors.equals("0")) ? true : false;
	}
}
