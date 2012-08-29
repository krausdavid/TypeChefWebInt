
public enum ProjectType {
	PROJECT("project"),COMPARE("compare");
	
	String s;
	
	ProjectType(String s){
		this.s = s;
	}
	
	public String getString(){
		return s;
	}
}
