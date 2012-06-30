
public enum ErrorState {
	NOTHING("false"),
	NOCHANGE("nochange"),DELETED("deleted"),CREATED("created"),
	NOWCOMPILEERROR("nowcompileerror"),NOWNOCOMPILEERROR("nownocompileerror"),COMPILEERROR("true"),
	NOWEXCLUDED("nowexcluded"),NOWNOEXCLUDED("nownoexcluded"),EXCLUDED("true");
	
	String s;
	
	ErrorState(String s){
		this.s = s;
	}
	
	public String getString(){
		return s;
	}
}
