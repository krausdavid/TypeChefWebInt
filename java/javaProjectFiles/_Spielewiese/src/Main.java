import java.io.File;

public class Main {
	
	public static void main(String[] args) {

		File f = new File("c:\\temp");
		File[] farr = f.listFiles();
		for(int i=0;i<farr.length;i++){
			if(farr[i].getName().endsWith(".project")){
				System.out.println(farr[i].getName().substring(0, farr[i].getName().indexOf(".project")));
			}
		}
	}

}
