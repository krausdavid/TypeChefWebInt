import java.util.ArrayList;

public class ListDifferences<T> {
	/**
	 * This method looks for deleted files.<br>
	 * Ex: If Project A contains file "a" and Project B doesn't contains file "a", this
	 * algorithm will find this difference
	 * @param main
	 * @param compare
	 * @return
	 */
	public Tuple<Tuple<ArrayList<T>,ArrayList<T>>,Tuple<ArrayList<T>,ArrayList<T>>> getListDiffs(ArrayList<T> main, ArrayList<T> compare){
		ArrayList<T> mMap = new ArrayList<T>();
		ArrayList<T> cMap = new ArrayList<T>();
		ArrayList<T> withoutDeletedMain = new ArrayList<T>();
		ArrayList<T> withoutDeletedCompare = new ArrayList<T>();
		
		for(int i=0;i<main.size();i++){
			mMap.add(main.get(i));
		}
		for(int i=0;i<compare.size();i++){
			cMap.add(compare.get(i));
		}
		
		for(int i=0;i<main.size();i++){
			if(cMap.contains(main.get(i))){
				cMap.remove(main.get(i));
				withoutDeletedMain.add(main.get(i));
			}
		}
		
		for(int i=0;i<compare.size();i++){
			if(mMap.contains(compare.get(i))){
				mMap.remove(compare.get(i));
				withoutDeletedCompare.add(compare.get(i));
			}
		}
		
		Tuple<ArrayList<T>,ArrayList<T>> t_1 = new Tuple<ArrayList<T>,ArrayList<T>>(mMap,withoutDeletedMain);
		Tuple<ArrayList<T>,ArrayList<T>> t_2 = new Tuple<ArrayList<T>,ArrayList<T>>(cMap,withoutDeletedCompare);
		
		Tuple<Tuple<ArrayList<T>,ArrayList<T>>,Tuple<ArrayList<T>,ArrayList<T>>> t = new Tuple<Tuple<ArrayList<T>,ArrayList<T>>,Tuple<ArrayList<T>,ArrayList<T>>>(t_1,t_2);
		return t;
	}
}
