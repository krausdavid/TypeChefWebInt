import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.util.ArrayList;

/**
 * A little program to scan a path (recursively) for "true succeeded" files from TypeChef
 * @author EifX
 *
 */
public class DBGFileChecker {
	
	private static ArrayList<File> files = new ArrayList<File>();
	private static ArrayList<String> sysOutput = new ArrayList<String>();
	private static final String VERSION = "0.3.1.1";
	
	/**
	 * Get all files from an given path
	 * @param path
	 * @return
	 */
	public static boolean getAllFiles(String path){
		File file = new File(path);
		File[] fileList = file.listFiles();
		try{
			for(int i=0;i<fileList.length;i++){
				if(fileList[i].isDirectory()){
					System.out.println("/");
					getAllFiles(fileList[i].getAbsolutePath());
				}else{
					if(fileList[i].toString().substring(fileList[i].toString().length()-4, fileList[i].toString().length()).equals(".dbg")){
						if(fileList[i].canRead()){
							files.add(fileList[i]);
							System.out.print(".");
						}
					}
				}
			}
		}catch (Exception e){
			out("[ERR]: ERROR IN NAVIGATION!");
			return false;
		}
		return true;
	}
	
	/**
	 * A simply help output
	 */
	public static void help(){
		out("Help - DBGFileChecker "+VERSION+" - by EifX");
		out("------------------------------------");
		out("");
		out("No help needed now ;)");
		/*out("Usage: DBGFileChecker [PATH] ([TXT-FILE]) [NORMAL_ERROR_OPTIONS] [TYPE_ERROR_OPTIONS]");
		out("");
		out("[PATH]:");
		out("");
		out("     Path for scan. Work with absolute and relative paths. If no path is set, the standart");
		out("     path will be used for scan.");
		out("");
		out("[TXT-FILE]: (Optional)");
		out("");
		out("     Path for text-file output. Works like [PATH].");
		out("");
		out("[*_ERROR_OPTIONS]");
		out("");
		out("     t          Only error files will be displayed");
		out("");
		out("     f          Only correct files will be displayed");
		out("");
		out("     a          All files will be displayed");
		out("");
		out("Sample:");
		out("");
		out("DBGFileChecker samplepath sampletxtfile a a");*/

	}
	
	/**
	 * Returns for a file <tt>true</tt> or <tt>false</tt> if TypeChef said "True succeeded" or not
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public static String ifTrueSucc(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		String str = file.readLine();
		while(str!=null){
			if(str.contains("True\tsucceeded")){
				file.close();
				return " OK ";
			}
			str = file.readLine();
		}
		file.close();
		return "FAIL";
	}
	
	/**
	 * Check if a given file is empty
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public static boolean isEmpty(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		if(file.length()==0){
			file.close();
			return true;
		}else{
			file.close();
			return false;
		}
	}
	
	/**
	 * Returns for a file <tt>true</tt> or <tt>false</tt> if TypeChef said "No type errors found." or not
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public static String ifNoTypeError(String path) throws IOException{
		RandomAccessFile file = new RandomAccessFile(path,"r");
		String str = file.readLine();
		while(str!=null){
			if(str.contains("No type errors found.")){
				file.close();
				return " OK ";
			}
			str = file.readLine();
		}
		file.close();
		return "FAIL";
	}
	
	/**
	 * Puts out an text in the console and save it to an ArrayList for the writeTxt-Method
	 * @param text
	 */
	public static void out(String text){
		sysOutput.add(text);
		System.out.println(text);
	}
	
	/**
	 * Write the output filefalse
	 * @param path
	 * @param prettyOutput 
	 */
	public static void writeTxt(String path){
		try{
			File f = new File(path);
			f.delete();
			RandomAccessFile file = new RandomAccessFile(path,"rw");
			for(int i=0;i<sysOutput.size();i++){
				file.writeBytes(sysOutput.get(i)+"\r\n");
			}
			file.close();
		}catch (IOException e){
			out("[ERR]: TEXTFILE WRITE ERROR IN: "+path);
		}
	}
	
	public static String isCorrectPath(String path){
		if(path.startsWith("\"")||path.startsWith("/")){
			path = path.substring(1);
		}
		File newFile = new File(path);
		if(!newFile.exists()){
			File actualPath = new File("");
			
			File extendedFile = new File(actualPath.getAbsolutePath()+path);
			if(extendedFile.exists()){
				return extendedFile.getAbsolutePath();
			}else{
				return null;
			}
		}
		
		if(newFile.exists()){
			return newFile.getAbsolutePath();
		}else{
			return null;
		}
	}
	
	public static String isCorrectFile(String path){
		if(path!=""){
			boolean isWin = true;
			int pos = 0;
			if(path.lastIndexOf('\\')>=0){
				pos = path.lastIndexOf('\\');
			}else{
				pos = path.lastIndexOf('/');
			}
			
			File f = new File("");
			if(f.getAbsolutePath().startsWith("/")){
				isWin=false;
			}
			
			if(pos==-1){
				if(isWin){
					return isCorrectPath("")+"\\"+path;
				}else{
					return isCorrectPath("")+"/"+path;
				}
			}else{
				if(isCorrectPath(path.substring(0, pos))!=null){
					return isCorrectPath(path.substring(0, pos))+path.substring(pos);
				}else{
					return null;
				}
			}
		}else{
			return null;
		}
	}
	
	public static String[] doDisplay() throws IOException{
		boolean inputRight = false;
		BufferedReader console = new BufferedReader(new InputStreamReader(System.in));
		File actualPath = new File("");

		System.out.println("Welcome to DBGFileChecker "+VERSION+" - by EifX");
		System.out.println("-------------------------------------------");
		System.out.println();
		System.out.println("[INFO]: Actual working directory: "+actualPath.getAbsolutePath());
		
		String path ="";
		while(inputRight==false){
			System.out.println();
			System.out.print("[INPT]: Insert path for scan: ");
			path = isCorrectPath(console.readLine());
			if(path!=null){
				System.out.println("[ OK ]: "+path);
				inputRight=true;
			}else{
				System.out.println("[ERR ]: No such directory!");
			}
		}
		
		inputRight = false;
		String outPath = "";
		while(inputRight==false){
			System.out.println();
			System.out.print("[INPT]: Insert path for output (empty for no text-file-output): ");
			String output = console.readLine();
			outPath = isCorrectFile(output);
			if(outPath!=null||output.equals("")){
				if(output.equals("")){
					System.out.println("[ OK ]: No output in a file");
					outPath = "";
				}else{
					System.out.println("[ OK ]: "+outPath);
				}
				inputRight=true;
			}else{
				System.out.println("[ERR ]: No such directory!");
			}
		}
		
		String truesucceeded = "";
		inputRight = false;
		while(inputRight==false){
			if(!truesucceeded.toLowerCase().startsWith("t")&&!truesucceeded.toLowerCase().startsWith("f")&&!truesucceeded.toLowerCase().startsWith("a")){
				if(truesucceeded!=""){
					System.out.print("ERROR!");
				}
				System.out.println();
				System.out.print("[INPT]: Normal errors: Display only True/False/All files? (t/f/a): ");
				truesucceeded = console.readLine();
			}else{
				System.out.println("[ OK ]");
				inputRight = true;
			}
		}
		
		String typeError = "";
		inputRight = false;
		while(inputRight==false){
			if(!typeError.toLowerCase().startsWith("t")&&!typeError.toLowerCase().startsWith("f")&&!typeError.toLowerCase().startsWith("a")){
				if(typeError!=""){
					System.out.println("ERROR!");
				}
				System.out.println();
				System.out.print("[INPT]: Type errors: Display only True/False/All files? (t/f/a): ");
				typeError = console.readLine();
			}else{
				System.out.println("[ OK ]");
				inputRight = true;
			}
		}
		String[] outStr = new String[4];
		outStr[0] = path;
		outStr[1] = outPath;
		outStr[2] = truesucceeded.substring(0,1);
		outStr[3] = typeError.substring(0,1);
		return outStr;
	}
	
	public static boolean doWork(String[] args) throws IOException{
		int normalError = 0, typeError = 0, allError = 0;
		boolean errnormal = false, errtype = false;
		if(!getAllFiles(args[0])){
			return false;
		}
		
		ArrayList<ErrorFile> newFileList = new ArrayList<ErrorFile>();
		ArrayList<File> emptyFiles = new ArrayList<File>();
		
		System.out.println("");
		System.out.println("[INFO]: Generating output... (drink a coffee and wait :D)");
		System.out.println("");

		Double dsize = new Double(files.size());
		int percent = 0;
		System.out.println("|0%       |50%      |100%");
		for(int i=0;i<files.size();i++){
			Double di = new Double(i);
			
			double calc = (di.doubleValue() / dsize.doubleValue())*100;
			
			if(calc>=0&&percent==0){System.out.print("|");percent=percent+5;}
			if(calc>=5&&percent==5){System.out.print("|");percent=percent+5;}
			if(calc>=10&&percent==10){System.out.print("|");percent=percent+5;}
			if(calc>=15&&percent==15){System.out.print("|");percent=percent+5;}
			if(calc>=20&&percent==20){System.out.print("|");percent=percent+5;}
			if(calc>=25&&percent==25){System.out.print("|");percent=percent+5;}
			if(calc>=30&&percent==30){System.out.print("|");percent=percent+5;}
			if(calc>=35&&percent==35){System.out.print("|");percent=percent+5;}
			if(calc>=40&&percent==40){System.out.print("|");percent=percent+5;}
			if(calc>=45&&percent==45){System.out.print("|");percent=percent+5;}
			if(calc>=50&&percent==50){System.out.print("|");percent=percent+5;}
			if(calc>=55&&percent==55){System.out.print("|");percent=percent+5;}
			if(calc>=60&&percent==60){System.out.print("|");percent=percent+5;}
			if(calc>=65&&percent==65){System.out.print("|");percent=percent+5;}
			if(calc>=70&&percent==70){System.out.print("|");percent=percent+5;}
			if(calc>=75&&percent==75){System.out.print("|");percent=percent+5;}
			if(calc>=80&&percent==80){System.out.print("|");percent=percent+5;}
			if(calc>=85&&percent==85){System.out.print("|");percent=percent+5;}
			if(calc>=90&&percent==90){System.out.print("|");percent=percent+5;}
			if(calc>=95&&percent==95){System.out.print("|");percent=percent+5;}
			if(calc>=100&&percent==100){System.out.print("|");percent=percent+5;}
			
			if(isEmpty(files.get(i).getPath())){
				emptyFiles.add(files.get(i));
			}else{
				if(ifTrueSucc(files.get(i).getPath()).equals("FAIL")){
					normalError++;
					errnormal = true;
				}
				if(ifNoTypeError(files.get(i).getPath()).equals("FAIL")){
					typeError++;
					errtype = true;
				}
				if(errnormal||errtype){
					allError++;
				}

				ErrorFile errFile = new ErrorFile(files.get(i).getPath(),errnormal,errtype);
				
				if(args[2].equals("t")&&args[3].equals("t")){
					if(!errnormal&&!errtype){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("t")&&args[3].equals("f")){
					if(!errnormal&&errtype){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("f")&&args[3].equals("t")){
					if(errnormal&&!errtype){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("t")&&args[3].equals("t")){
					if(errnormal&&errtype){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("t")&&args[3].equals("a")){
					if(!errnormal){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("f")&&args[3].equals("a")){
					if(errnormal){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("a")&&args[3].equals("t")){
					if(!errtype){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("a")&&args[3].equals("f")){
					if(errtype){
						newFileList.add(errFile);
					}
				}
				if(args[2].equals("a")&&args[3].equals("a")){
					newFileList.add(errFile);
				}
			}
			errnormal = false;
			errtype = false;
		}
		System.out.print("|");
		System.out.println("");
		System.out.println("");
		
		out("Output overview (with DBGFileChecker "+VERSION+" - by EifX):");
		out("----------------");
		out("");
		out("For path: "+args[0]);
		out("Scan settings: "+args[2]+","+args[3]);
		out("");
		out("Now comes the file-list:");
		out("------------------------");
		out("");
		out(" Error-Type | ");
		out("Norm.|TypErr| Path");
		out("-----|------|-------------------------------------");
		
		for(int i=0;i<newFileList.size();i++){
			out("["+newFileList.get(i).getNormalErr()+"]["+newFileList.get(i).getTypeErr()+"]: "+newFileList.get(i).getPath().replace(args[0],""));
		}
		
		if(emptyFiles.size()>0){
			out("Now the empty files without any content:");
			out("------------------------");
			out("");
			for(int i=0;i<emptyFiles.size();i++){
				out("[EMPT][----]: "+emptyFiles.get(i).getPath());
			}
		}
		
		out("");
		out("Summary:");
		out("--------");
		out("");
		out("Files scanned: "+files.size());
		out("Normal Errors: "+normalError);
		out("Type Errors  : "+typeError);
		out("Empty Files  : "+emptyFiles.size());
		out("");
		out("Files with errors   : "+(allError+emptyFiles.size()));
		out("Files without errors: "+(files.size()-allError-emptyFiles.size()));
		out("");
		out("ALL DONE!");
		return true;
	}
	

	public static void main(String[] args) {
		try {
/*			String[] outStr = new String[4];
			if(args.length==3){
				outStr[0] = args[0];
				outStr[1] = "";
				outStr[2] = args[1];
				outStr[3] = args[2];
			}
			if(args.length==4){
				outStr[0] = args[0];
				outStr[1] = args[1];
				outStr[2] = args[2];
				outStr[3] = args[3];
			}
			
			if(args.length!=3&&args.length!=4){
				outStr = doDisplay();
			}
*/			String[] outStr = doDisplay();
			long time = System.currentTimeMillis();
			if(!doWork(outStr)){
				System.out.println("UNKNOWN ERROR IN NAVIGATION!");
				System.exit(0);
			}
			out("");
			out("Scan duration: "+(System.currentTimeMillis()-time)+" msec");
			
			if(outStr[1]!=""){
				writeTxt(outStr[1]);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
