import java.util.ArrayList;
import tcwi.TCWIFile.ParserError;
import tcwi.TCWIFile.TypeError;


public class ErrorField {
	private ErrorState excluded;
	private ErrorState filestat;
	private ErrorState compileerror;
	
	private ArrayList<ParserError> delParserErrorsMain;
	private ArrayList<ParserError> delParserErrorsCompare;
	private ArrayList<TypeError> delTypeErrorsMain;
	private ArrayList<TypeError> delTypeErrorsCompare;
	
	public ErrorField(){
		this.excluded=ErrorState.NOTHING;
		this.compileerror=ErrorState.NOTHING;
		this.filestat=ErrorState.NOCHANGE;
		this.delParserErrorsMain = new ArrayList<ParserError>();
		this.delParserErrorsCompare = new ArrayList<ParserError>();
		this.delTypeErrorsMain = new ArrayList<TypeError>();
		this.delTypeErrorsCompare = new ArrayList<TypeError>();
	}

	public int getParsererrors() {
		return delParserErrorsMain.size()+delParserErrorsCompare.size();
	}

	public int getTypeerrors() {
		return delTypeErrorsMain.size()+delTypeErrorsCompare.size();
	}

	public ErrorState getExcluded() {
		return excluded;
	}

	public void setExcluded(ErrorState excluded) {
		this.excluded = excluded;
	}

	public ErrorState getCompileerror() {
		return compileerror;
	}

	public void setCompileerror(ErrorState compileerror) {
		this.compileerror = compileerror;
	}

	public ArrayList<ParserError> getDelParserErrorsMain() {
		return delParserErrorsMain;
	}

	public void setDelParserErrorsMain(ArrayList<ParserError> delParserErrorsMain) {
		this.delParserErrorsMain = delParserErrorsMain;
	}

	public ArrayList<ParserError> getDelParserErrorsCompare() {
		return delParserErrorsCompare;
	}

	public void setDelParserErrorsCompare(
			ArrayList<ParserError> delParserErrorsCompare) {
		this.delParserErrorsCompare = delParserErrorsCompare;
	}

	public ArrayList<TypeError> getDelTypeErrorsMain() {
		return delTypeErrorsMain;
	}

	public void setDelTypeErrorsMain(ArrayList<TypeError> delTypeErrorsMain) {
		this.delTypeErrorsMain = delTypeErrorsMain;
	}

	public ArrayList<TypeError> getDelTypeErrorsCompare() {
		return delTypeErrorsCompare;
	}

	public void setDelTypeErrorsCompare(ArrayList<TypeError> delTypeErrorsCompare) {
		this.delTypeErrorsCompare = delTypeErrorsCompare;
	}

	public ErrorState getFilestat() {
		return filestat;
	}

	public void setFilestat(ErrorState filestat) {
		this.filestat = filestat;
	}

}
