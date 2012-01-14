import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Prune {
	public static void main(String[] args) throws IOException {
		BufferedReader reader = new BufferedReader(new FileReader(args[0]));
		String l;
		int nesting = 0;
		int isnull = -1;
		while ((l = reader.readLine()) != null) {
			if (l.startsWith("#if"))
				nesting++;
			if (l.startsWith("#elif")) {
				if (isnull == nesting)
					isnull = -1;
			}
			if (l.startsWith("#endif")) {
				if (isnull == nesting)
					isnull = -1;
				nesting--;
			}
			if (!(isnull >= 0) && l.equals("#if 0"))
				isnull = nesting;
			if (!(isnull >= 0) && l.equals("#elif 0"))
				isnull = nesting;
			
			if (isnull==-1)
				System.out.println(l);
		}
	}
}

