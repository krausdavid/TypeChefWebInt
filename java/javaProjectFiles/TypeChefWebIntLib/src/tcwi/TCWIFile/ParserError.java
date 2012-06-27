package tcwi.TCWIFile;

public class ParserError {
	private String featurestr;
	private String msg;
	private String file;
	private String line;
	private String col;

	public ParserError(){
		this.featurestr="";
		this.msg="";
		this.file="";
		this.line="";
		this.col="";
	}
	
	public ParserError(String featurestr, String msg, String file, String line, String col) {
		this.featurestr = featurestr;
		this.msg = msg;
		this.file = file;
		this.line = line;
		this.col = col;
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

	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	public String getLine() {
		return line;
	}

	public void setLine(String line) {
		this.line = line;
	}

	public String getCol() {
		return col;
	}

	public void setCol(String col) {
		this.col = col;
	}

	
}
