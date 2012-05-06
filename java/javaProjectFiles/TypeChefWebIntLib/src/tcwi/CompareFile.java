package tcwi;

import java.util.ArrayList;

public class CompareFile extends TCWIFile<String>{
	
	@Override
	public String toString() {
		return this.path+"\t"+haveNoDBG+"\t"+isEmptyFile+"\t"+isNotTrueSucceeded+"\t"+haveTypeErrors;
	}
	
	public ArrayList<CompareFile> convertToCompareFileArr(ArrayList<TCWIFile> tcwiFileArr){
		ArrayList<CompareFile> compareFileArr = new ArrayList<CompareFile>();
		
		for(int i=0;i<tcwiFileArr.size();i++){
			compareFileArr.add((CompareFile) tcwiFileArr.get(i));
		}
		return compareFileArr;
	}
}
