package tcwi.xml;

import java.util.ArrayList;

import tcwi.TCWIFile.ErrorFile;

public class ProjectFile {
	private String idname;
	private String fullname;
	private String version;
	private String path;
	private String isDelta;
	private String mainproject;
	private String builder;
	private String date;
	private String time;
	private String parsererrors;
	private String typeerrors;
	private String excludedfiles;
	private String compileerrors;
	private ArrayList<ErrorFile> files;

	public ProjectFile(){
		this.idname="";
		this.fullname="";
		this.version="";
		this.path="";
		this.isDelta="";
		this.mainproject="";
		this.builder="";
		this.date="";
		this.time="";
		this.parsererrors="";
		this.typeerrors="";
		this.excludedfiles="";
		this.compileerrors="";
		this.files = new ArrayList<ErrorFile>();
	}

	public String getIdname() {
		return idname;
	}

	public void setIdname(String idname) {
		this.idname = idname;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
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

	public String getBuilder() {
		return builder;
	}

	public void setBuilder(String builder) {
		this.builder = builder;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getParsererrors() {
		return parsererrors;
	}

	public void setParsererrors(String parsererrors) {
		this.parsererrors = parsererrors;
	}

	public String getTypeerrors() {
		return typeerrors;
	}

	public void setTypeerrors(String typeerrors) {
		this.typeerrors = typeerrors;
	}

	public String getExcludedfiles() {
		return excludedfiles;
	}

	public void setExcludedfiles(String excludedfiles) {
		this.excludedfiles = excludedfiles;
	}

	public String getCompileerrors() {
		return compileerrors;
	}

	public void setCompileerrors(String compileerrors) {
		this.compileerrors = compileerrors;
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
