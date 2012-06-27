package tcwi.xml;

import java.util.ArrayList;

import tcwi.TCWIFile.CompareFile;
import tcwi.TCWIFile.ErrorFile;
import tcwi.TCWIFile.TCWIFile;

public class ProjectFile {
	private String idname;
	private String fullname;
	private String version;
	private String path;
	private String type;
	private String hasDeltas;
	private String mainproject;
	private String builder;
	private String date;
	private String time;
	private String parsererrors;
	private String typeerrors;
	private String excludedfiles;
	private String compileerrors;
	private ArrayList<TCWIFile> files;

	public ProjectFile(){
		this.idname="";
		this.fullname="";
		this.version="";
		this.path="";
		this.type="";
		this.hasDeltas="";
		this.mainproject="";
		this.builder="";
		this.date="";
		this.time="";
		this.parsererrors="";
		this.typeerrors="";
		this.excludedfiles="";
		this.compileerrors="";
		this.files = new ArrayList<TCWIFile>();
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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getHasDeltas() {
		return hasDeltas;
	}

	public void setHasDeltas(String hasDeltas) {
		this.hasDeltas = hasDeltas;
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

	public ArrayList<TCWIFile> getFiles() {
		return files;
	}

	public void addFile(TCWIFile file) {
		this.files.add(file);
	}

	public int getParserErrorsCount() {
		int pErr = 0;
		for(int i=0;i<files.size();i++){
			if(this.type.equals("normal")){
				ErrorFile e = (ErrorFile) files.get(i);
				pErr += e.getParserError().size();
			}
			if(this.type.equals("compare")){
				CompareFile c = (CompareFile) files.get(i);
				pErr += c.getParserErrorDiffCount();
			}
		}
		return pErr;
	}

	public int getTypeErrorsCount() {
		int tErr = 0;
		for(int i=0;i<files.size();i++){
			if(this.type.equals("normal")){
				ErrorFile e = (ErrorFile) files.get(i);
				tErr += e.getTypeError().size();
			}
			if(this.type.equals("compare")){
				CompareFile c = (CompareFile) files.get(i);
				tErr += c.getTypeErrorDiffCount();
			}
		}
		return tErr;
	}
	
	public boolean haveErrors(){
		return (getParserErrorsCount()+getTypeErrorsCount())>0 ? true : false;
	}
}
