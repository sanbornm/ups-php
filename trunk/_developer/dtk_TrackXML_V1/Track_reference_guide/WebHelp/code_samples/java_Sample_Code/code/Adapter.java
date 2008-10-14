
//Sun's java package 
import java.io.*;
import java.util.*;

//xml java API
import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.helpers.*;
import com.ibm.xml.framework.*;

//XML parser
import com.ibm.xml.parser.*;
import com.ibm.xml.parsers.*;
//import javax.xml.parsers.*;

/**
 * The Adapter class converts objects into XML,
 * and parse XML returned into objects
 */

public abstract class Adapter 
{
	
	private Document reqDoc;
	
protected Adapter()
{
	super();
}
/**
 * Method converts an object into XML as a StringBuffer, 
 *  real code will be writen in individual adapter.
 *
 * @return java.lang.StringBuffer
 * @param aServReqContainer java.lang.Object
 */
public abstract StringBuffer adaptFromObject(java.lang.Object aServReqContainer) throws Exception;
/**
 * Method takes an XML document as a StringBuffer, 
 * parses the XML document, and returns into objects.
 * 
 * real code will be writen in individual adapter.
 * @param java.lang.StringBuffer document
 * @return java.lang.Object
 */
public abstract java.lang.Object adaptFromXml(StringBuffer document) throws Exception;
/** adds a new element tag with text node date, e.g. <City>Timonium</City>
 * if 'str' is null, the element is added as an "empty" element
 *  e.g. <City/>
 */
public static void addNode(Document doc, String strParentTag, String newTagName, String textString, String attrName, String attrValue)
{
  	Element item = doc.createElement(newTagName); 	// this creates the new element tag
	Node parentTag = doc.getDocumentElement(); 		// default parent to root

	// we are getting a nodelist because it allows us to specify the parent element
	// by its string name; that way, we don't have to pass Elements around
	NodeList nl = doc.getDocumentElement().getElementsByTagName(strParentTag);
	parentTag = nl.item(nl.getLength()-1);

	try 
	{
		if (textString != null) 
		{
			// we support #RM, which means, 'do not add this node'
		   	if(!textString.startsWith("#RM") && !textString.startsWith("#rm"))
		   	{
				item.appendChild(doc.createTextNode(textString));
				parentTag.appendChild(item);
			}
		}
		else 
		{
			if(attrName != null && attrValue != null)
				item.setAttribute(attrName, attrValue);
			parentTag.appendChild(item);
		}
	}
	catch (Exception e) { e.printStackTrace();}
}
/**
 * This method builds an part of the DOM tree and attaches it to the document using recursion
 */
public static void buildNode(Document doc, String strParentTag, String nodeName, Vector data)
{
	addNode(doc, strParentTag, nodeName, null, null, null);

	Enumeration e = data.elements();
	while(e.hasMoreElements()) 
	{
		Vector v = (Vector) e.nextElement();
		if(v.elementAt(1) instanceof Vector)
			buildNode(doc, nodeName, (String) v.elementAt(0), (Vector) v.elementAt(1));
		else 
			addNode(doc, nodeName, (String) v.elementAt(0), (String) v.elementAt(1), null, null);
	}
}
// This method takes two elements and combines them as a "name-value" pair in a vector
public static Vector buildVector(String s1, Object s2)
{
	Vector v = new Vector();
	v.addElement(s1);
	v.addElement(s2);
	return(v);
}
/**
 * This method creates the XML document and its root node
 */
protected Document createXMLDocument(String rootName) throws Exception
{
	
	//use IBM XML4J package
	try{
	Document doc = new TXDocument();
	//use JAXP
	/*
		DocumentBuilderFactory dfactory =
		  DocumentBuilderFactory.newInstance();
		dfactory.setNamespaceAware(true);
		DocumentBuilder docBuilder = dfactory.newDocumentBuilder();
		org.w3c.dom.Document doc = docBuilder.newDocument();
	*/
	
	Element root = doc.createElement(rootName);
	doc.appendChild(root);
	return doc;
	}catch(Exception e)
	{
		System.out.println("Error in createXMLDocument" + e.getMessage());
		throw new Exception ("Error in createXMLDocument" + e);
	}
}
/**
 * 
 * 
 * 
 * @return java.lang.StringBuffer
 * @param doc org.w3c.dom.Document
 */
protected StringBuffer docToBuffer(Document doc) throws Exception
{
	StringWriter sw = new StringWriter();
	try
	{
		//use IBM XML4J package
		((com.ibm.xml.parser.TXDocument) doc).setVersion("1.0");
		((com.ibm.xml.parser.TXDocument) doc).printWithFormat(sw);
	} catch (Exception e)
	{
		throw e;
	}
	return sw.getBuffer();
}
/**
 * Method to get a node that is a child of parent
 * @return Node the node found
 * @param Node the parent of the node you are looking for
 * @param String the name of the node you are looking for
 */
protected org.w3c.dom.Node getChildNode(org.w3c.dom.Node parent, String nodeName)
{
	if (parent == null)
		return null;
	
	org.w3c.dom.Node child = null;
	org.w3c.dom.Node found = null;
	for (child = parent.getFirstChild(); child != null; child = child.getNextSibling())
	{
		if (child.getNodeName().equals(nodeName))
		{
			found = child;
			break;
		}
	}
	
	return found;
}
/**
 * Method to get a value of a node based on the node's name and its parent
 * @return String the value of the found node
 * @param Node the parent of the node you are looking for
 * @param String the name of the node you are looking for
 */
protected String getChildNodeValue(org.w3c.dom.Node node, String fieldName)
{
	if (node == null)
		return "";
	String value = "";
	org.w3c.dom.Node found = null;
	for (org.w3c.dom.Node child = node.getFirstChild(); child != null; child = child.getNextSibling())
	{
		if (child.getNodeName().equals(fieldName))
		{
			found = child;
			value = getNodeValue(child);
			break;
		}
	}
	if (found == null)
		return "";
	return value.trim();
}
/**
 * Method to get a DOM document from an XML string
 * @return the document
 * @param String the XML String
 */
protected Document getDocument(String adaptee) throws Exception
{
	//use IBM's XML4J 
	com.ibm.xml.parsers.DOMParser parser = null;

	//use Sun's JAXP
	
	 //javax.xml.parsers.DocumentBuilder parser =null;
	

	Document doc = null;

	try
	{
		StringReader adapteeReader = new StringReader(adaptee);
		InputSource input = new InputSource(adapteeReader);
		//use IBM's XML4J
		parser = new com.ibm.xml.parsers.DOMParser();
		if (parser != null)
		{
			parser.parse(input);
			doc = parser.getDocument();
		}else
			System.out.println("Failed to create a parser in getDocument.");
		

		//use Sun's JAXP
		
		/*
		 javax.xml.parsers.DocumentBuilderFactory dfactory =
		  javax.xml.parsers.DocumentBuilderFactory.newInstance();
		dfactory.setNamespaceAware(true);
		parser = dfactory.newDocumentBuilder();
		doc = parser.parse(input);
		*/
				
	}
	
	catch (SAXException sx)
	{
		Exception ex = sx.getException();
		if (ex != null)
		{
			PrintStream stream = null;
			ex.printStackTrace(stream);
		}
		else
		{
			PrintStream stream = null;
			sx.printStackTrace(stream);
		}
		System.out.println("SAXException in getDocument.");
		throw sx;
	}
	catch (FileNotFoundException fnf)
	{
		System.out.println(fnf.getMessage());
		throw fnf;
	}
	catch (IOException ioe)
	{
		System.out.println(ioe.getMessage());
		throw ioe;
	}
	return doc;
}
/**
 * Method to get the value (text) of a node
 * @return String the value
 * @param Node the node to get the value from
 */
protected String getNodeValue(Node node)
{
	String output = new String("");
	NodeList nl = null;

	if (node != null)
		nl = node.getChildNodes();

	if ((nl != null) && (nl.getLength() > 0))
	{
		Node value = nl.item(0);
		if (value != null)
			output = value.getNodeValue();
	}

	output = output.trim();
	return output;
}
public static void main(String[] args) 
{
	System.out.println("This is not an application and is for reference only. Please view the source code for an example of building and parsing XML documents.");
}
}
