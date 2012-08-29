package tcwi.TCWIFile;

public class TypeError {
	private String featurestr;
	private String msg;
	private String severity;
	private String fromFile;
	private String fromLine;
	private String fromCol;
	private String toFile;
	private String toLine;
	private String toCol;
	
	public TypeError(){
		this.featurestr="";
		this.msg="";
		this.severity="";
		this.fromFile="";
		this.fromLine="";
		this.fromCol="";
		this.toFile="";
		this.toLine="";
		this.toCol="";
	}
	
	public TypeError(String featurestr, String msg, String severity, String fromFile, String fromLine, String fromCol, String toFile, String toLine, String toCol) {
		this.featurestr = featurestr;
		this.msg = msg;
		this.severity = severity;
		this.fromFile = fromFile;
		this.toFile = toFile;
		this.fromLine = fromLine;
		this.fromCol = fromCol;
		this.toLine = toLine;
		this.toCol = toCol;
	}

	public String getFeaturestr() {
		return featurestr;
	}

	public void setFeaturestr(String featurestr) {
		this.featurestr = featurestr;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getSeverity() {
		return severity;
	}

	public void setSeverity(String severity) {
		this.severity = severity;
	}

	public String getFromFile() {
		return fromFile;
	}

	public void setFromFile(String fromFile) {
		this.fromFile = fromFile;
	}

	public String getToFile() {
		return toFile;
	}

	public void setToFile(String toFile) {
		this.toFile = toFile;
	}

	public String getFromLine() {
		return fromLine;
	}

	public void setFromLine(String fromLine) {
		this.fromLine = fromLine;
	}

	public String getFromCol() {
		return fromCol;
	}

	public void setFromCol(String fromCol) {
		this.fromCol = fromCol;
	}

	public String getToLine() {
		return toLine;
	}

	public void setToLine(String toLine) {
		this.toLine = toLine;
	}

	public String getToCol() {
		return toCol;
	}

	public void setToCol(String toCol) {
		this.toCol = toCol;
	}

	public boolean equals(TypeError o){
		if(this.featurestr.equals(o.getFeaturestr()) && this.msg.equals(o.getMsg()) && this.severity.equals(o.getSeverity()) && this.fromFile.equals(o.getFromFile()) && this.fromLine.equals(o.getFromLine()) && this.fromCol.equals(o.getFromCol()) && this.toFile.equals(o.getToFile()) && this.toLine.equals(o.getToLine()) && this.toCol.equals(o.getToCol())){
			return true;
		}else{
			return false;
		}
	}
}
