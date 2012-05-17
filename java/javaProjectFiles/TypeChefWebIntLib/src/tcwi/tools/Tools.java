package tcwi.tools;

public class Tools {
	/**
	 * Returns a correct formatted number
	 * @param str
	 * @return
	 */
	public static String correctCalendarForm(int i){
		String str = i+"";
		if(str.length()==1){
			return "0"+str;
		}else{
			return str;
		}
	}
}
