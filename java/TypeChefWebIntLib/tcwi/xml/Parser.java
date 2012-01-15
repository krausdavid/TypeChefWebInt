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

/**
 * A XML-Parser for TypeChefWebInt
 * @author EifX
 * @version 0.0.0.1
 *
 */
public class Parser {
	private String setting_file;
	
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

	public String getSetting_file() {
		return setting_file;
	}
	
}
