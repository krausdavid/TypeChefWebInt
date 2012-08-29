package tcwi.xml;

import java.util.ArrayList;

import tcwi.TCWIFile.ErrorCompareFile;

public class CompareFile extends MasterFile{
	private String newfiles;
	private String deletedfiles;
	private ArrayList<ErrorCompareFile> files;

	public CompareFile(){
		super();
		this.newfiles="";
		this.deletedfiles="";
		this.files = new ArrayList<ErrorCompareFile>();
	}

	public String getNewfiles() {
		return newfiles;
	}

	public void setNewfiles(String newfiles) {
		this.newfiles = newfiles;
	}

	public String getDeletedfiles() {
		return deletedfiles;
	}

	public void setDeletedfiles(String deletedfiles) {
		this.deletedfiles = deletedfiles;
	}

	public ArrayList<ErrorCompareFile> getFiles() {
		return files;
	}

	public void addFile(ErrorCompareFile file) {
		this.files.add(file);
	}

	public boolean haveErrors(){
		return (!parsererrors.equals("0")||!typeerrors.equals("0")||!compileerrors.equals("0")) ? true : false;
	}
}
