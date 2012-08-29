package tcwi.xml;

public class MasterFile {
	protected String idname;
	protected String fullname;
	protected String path;
	protected String builder;
	protected String date;
	protected String time;
	protected String parsererrors;
	protected String typeerrors;
	protected String excludedfiles;
	protected String compileerrors;

	public MasterFile(){
		this.idname="";
		this.fullname="";
		this.path="";
		this.builder="";
		this.date="";
		this.time="";
		this.parsererrors="";
		this.typeerrors="";
		this.excludedfiles="";
		this.compileerrors="";
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

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
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
}
