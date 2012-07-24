
public class FolderElem {
	private boolean isFail;
	private String path;
	
	public FolderElem(boolean isFail, String path){
		this.isFail = isFail;
		this.path = path;
	}

	public boolean isFail() {
		return isFail;
	}

	public void setFail(boolean isFail) {
		this.isFail = isFail;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
	
	
}
