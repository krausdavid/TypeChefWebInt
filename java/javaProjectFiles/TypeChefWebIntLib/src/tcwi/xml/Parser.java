package tcwi.xml;
import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import tcwi.TCWIFile.ErrorFile;
import tcwi.TCWIFile.ParserError;
import tcwi.TCWIFile.TypeError;
import tcwi.exception.Exceptions;

/**
 * A XML-Parser for TypeChefWebInt
 * 
 */
public class Parser {
	private String setting_file;
	private Exceptions exception = new Exceptions();
	
	/**
	 * Creates an XML Object
	 * @param setting_file An absolute Path to a XML-Document
	 */
	public Parser(String setting_file){
		this.setting_file = setting_file;
	}
	
	/**
	 * Reads a setting in a given setting-file<br>
	 * @param settings A String arr for the XML-Path<br><br>
	 * 
	 * Example:<br>
	 * &lt;test&gt;<br>
	 * &nbsp;&nbsp;&lt;node&gt;<br>
	 * &nbsp;&nbsp;&nbsp;&nbsp;&lt;setting path="/foo/bar/foobar.txt" /&gt;<br>
	 * &nbsp;&nbsp;&lt;/node&gt;<br>
	 * &lt;/test&gt;<br><br>
	 * 
	 * Your String-Array: <br>
	 * String[] xpath = {"test","node","setting","path"};<br><br>
	 * 
	 * Settings like &lt;test&gt;foobar&lt;/test&gt; are not excepted!<br>
	 * 
	 * @return Your setting as a String
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public String read_setting(String[] settings) throws ParserConfigurationException, SAXException, IOException{
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder = factory.newDocumentBuilder();
	    Document document = builder.parse( new File(setting_file) );
	    NodeList list = document.getChildNodes();

	    //Go to a deeper path
	    for(int i=0;i<settings.length;i++){
	    	if(settings.length-2>i){
		    	for(int j=0;j<list.getLength();j++){
		    		if(list.item(j).getNodeName()==settings[i]){
		    			list = list.item(j).getChildNodes();
		    			break;
		    		}
		    	}
	    	}else{
	    		//Node found, try to get his specific value
	    		for(int j=0;j<list.getLength();j++){
	    			if(list.item(j).getNodeName()==settings[i]){
	    				NamedNodeMap attr = list.item(j).getAttributes();
	    				for(int k=0;k<attr.getLength();k++){
	    					if(attr.item(k).getNodeName()==settings[i+1]){
	    						return attr.item(k).getNodeValue();
	    					}
	    				}
	    			}
	    		}
	    	}
	    }

		return "";
	}
	
	private static String removeWhites(String str){
		str = str.replace("\t", "");
		str = str.replace("\r", "");
		str = str.replace("\n", "");
		
		String newStr = str;
		for(int i=0;i<newStr.length();i++){
			if(newStr.charAt(i)==' '){
				str = str.substring(1);
			}else{
				break;
			}
		}
		newStr = str;
		for(int i=newStr.length()-1;i>0;i--){
			if(newStr.charAt(i)==' '){
				str = str.substring(0,str.length()-1);
			}else{
				break;
			}
		}
		return str;
	}
	
	/**
	 * This method get all data from given .c.xml and returns it as an ErrorFile
	 * @param path
	 * @return
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public static ErrorFile getAllErrors(String path) throws ParserConfigurationException, SAXException, IOException{
		ErrorFile err = new ErrorFile();
		err.setPath(path.substring(0,path.length()-6));
		
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder = factory.newDocumentBuilder();
	    Document document = builder.parse(new File(path));
	    NodeList list = document.getChildNodes().item(0).getChildNodes();
				    
	    for(int i=0;i<list.getLength();i++){
	    	if(list.item(i).getNodeName().equals("typeerror")){
	    		String featurestr = "", msg = "", severity = "", fromFile = "",  fromLine = "", fromCol = "", toFile = "", toLine = "", toCol = "";
		    	boolean firstPos = true;
	    		for(int j=0;j<list.item(i).getChildNodes().getLength();j++){
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("featurestr")){
	    				featurestr = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(0).getNodeValue());
	    			}
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("msg")){
	    				msg = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(0).getNodeValue());
	    			}
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("severity")){
	    				severity = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(0).getNodeValue());
	    			}
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("position")){
	    				for(int k=0;k<list.item(i).getChildNodes().item(j).getChildNodes().getLength();k++){
		    				if(firstPos==true){
		    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("file")){
				    				fromFile = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
		    					}
		    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("line")){
				    				fromLine = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
		    					}
		    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("col")){
				    				fromCol = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
		    					}
		    					firstPos = false;
		    				}else{
		    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("file")){
				    				toFile = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
		    					}
		    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("line")){
				    				toLine = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
		    					}
		    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("col")){
				    				toCol = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
		    					}
		    				}
	    				}
	    			}
	    		}
	    		TypeError tErr = new TypeError(featurestr, msg, severity, fromFile,  fromLine, fromCol, toFile, toLine, toCol);
	    		err.addError(tErr);
	    	}
	    	if(list.item(i).getNodeName().equals("parsererror")){
	    		String featurestr = "", msg = "", file = "", line = "", col = "";
	    		for(int j=0;j<list.item(i).getChildNodes().getLength();j++){
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("featurestr")){
	    				featurestr = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(0).getNodeValue());
	    			}
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("msg")){
	    				msg = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(0).getNodeValue());
	    			}
	    			if(list.item(i).getChildNodes().item(j).getNodeName().equals("position")){
	    				for(int k=0;k<list.item(i).getChildNodes().item(j).getChildNodes().getLength();k++){
	    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("file")){
			    				file = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
	    					}
	    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("line")){
			    				line = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
	    					}
	    					if(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getNodeName().equals("col")){
			    				col = removeWhites(list.item(i).getChildNodes().item(j).getChildNodes().item(k).getChildNodes().item(0).getNodeValue());
	    					}
	    				}
	    			}
	    		}
	    		ParserError pErr = new ParserError(featurestr, msg, file, line, col);
	    		err.addError(pErr);
	    	}
	    }
	    return err;
	}

	public String getSetting_file() {
		return setting_file;
	}
	
	/**
	 * A method to get an setting from an given setting-file
	 * @param globalSettings
	 * @param xpath
	 * @return
	 */
	public String getSetting(String[] xpath){
		Parser parser = new Parser(this.setting_file);
		String pathOutput = "";

		try{
			pathOutput = parser.read_setting(xpath);
		} catch (IOException e) {
			exception.throwException(1, e, true, "");
		} catch (Exception e) {
			String path = "";
			for(int i=0;i<xpath.length;i++){
				path += xpath[i]+" ";
			}
			exception.throwException(2, e, true, path);
		}
		return pathOutput;		
	}
	
	/**
	 * A specific method to get the project-path from the WebInt
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_ProjectPath(){
		String[] xpath = {"settings","global","projects","path"};
		return this.getSetting(xpath);
	}
	
	/**
	 * A specific method to get the treeview-path
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_TreeviewPath(){
		String[] xpath = {"settings","website","generic","treeview","path"};
		return this.getSetting(xpath);
	}

	/**
	 * A specific method to get the treeview-icons-path
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_TreeviewIconsPath(){
		String[] xpath = {"settings","website","generic","treeview","icons"};
		return this.getSetting(xpath);
	}

	/**
	 * A specific method to get the project default URI
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_WebsiteDefaultURI(){
		String[] xpath = {"settings","global","website","defaultURI"};
		return this.getSetting(xpath);
	}
	
	/**
	 * A specific method to get the version from an project
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_ProjectVersion(){
		String[] xpath = {"settings","global","project","version"};
		return this.getSetting(xpath);
	}
	
	/**
	 * A specific method to get the path from a specific project
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_ProjectBasePath(){
		String[] xpath = {"settings","global","project","path"};
		return this.getSetting(xpath);
	}
	
	/**
	 * A specific method to get the information, if the project have failures
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_ProjectFailureProject(){
		String[] xpath = {"settings","global","project","failureProject"};
		return this.getSetting(xpath);
	}
	
	/**
	 * A specific method to get the full project name
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_ProjectFullname(){
		String[] xpath = {"settings","global","project","fullname"};
		return this.getSetting(xpath);
	}
	
	/**
	 * A specific method to get the information about the project type
	 * @param globalSettings
	 * @return
	 */
	public String getSetting_ProjectType(){
		String[] xpath = {"settings","global","project","type"};
		return this.getSetting(xpath);
	}
}
