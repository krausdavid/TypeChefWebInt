
public class ErrorFile {
	private String path;
	private String normalErr;
	private String typeErr;
	
	public ErrorFile(String path, boolean normalErr, boolean typeErr) {
		this.path = path;
		if(normalErr){
			this.normalErr = "FAIL";
		}else{
			this.normalErr = " OK ";
		}
		if(typeErr){
			this.typeErr = "FAIL";
		}else{
			this.typeErr = " OK ";
		}
	}

	public String getPath() {
		return path;
	}

	public String getNormalErr() {
		return normalErr;
	}

	public String getTypeErr() {
		return typeErr;
	}


	
}
