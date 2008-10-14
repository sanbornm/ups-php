/*  uncomment if intending to reinable proxy popup
import java.awt.*;
import java.awt.event.*;
*/
import com.ibm.sslite.SSLContext;
import com.ibm.sslite.SSLPKCS12Token;
import com.ibm.sslite.SSLCert;
import java.io.*;
import java.util.*;
import java.net.*;

/**  the Proxy class enables protocol handling and proxy authentication
 *   with SSLight
 */
public class Proxy
{
	private static java.lang.String username;
	private static java.lang.String password;
/**
 * Constructor used for proxy authentication with SSLight.
 * @param username java.lang.String
 * @param password java.lang.String
 */
public Proxy(String username, String password)
{
	this.username = username;
	this.password = password;
}
	// This method is called by HTTPS protccol handler
	// when server authentication is detected.
	public String authString (URL u, String scheme, String realm) {
	// u:       URL of requested entity which is protected
	// scheme:  the authentication scheme (in 99.99% of all cases: "basic")

	// Note: this API is in accordance with JDKs HTTP callback and HTTP
		// does not pass a retry counter. Therefore, we call common handler with 0.
	
	// Call common handler for proxy authentication & server authentication
	// Return authentication string or null (user did cancel dialog - no information available)
	return authString(u, scheme, realm, 0);
	}
// Common handler for proxy authentication & server authentication
private String authString(URL u, String scheme, String realm, int retries)
{
	/*Frame f = new Frame();
	final Dialog d = new Dialog(f,
	    (realm==null?"Proxy Authentication":"WWW Authentication")+
	    (retries==0?"":" (Retry "+retries+")"), true);
	d.setLayout(new GridBagLayout());
	GridBagConstraints g = new GridBagConstraints();
	g.gridx = g.gridy = 0;
	g.gridwidth = 2;
	d.add(new Label("URL: "+u), g);
	if( realm!=null ) {
	    g.gridy = 1;
	    d.add(new Label("Realm: "+realm), g);
	}
	g.gridwidth = 1;
	g.gridy = 2;
	d.add(new Label("User: "), g);
	g.gridy = 3;
	d.add(new Label("Password: "), g);
	g.gridx = 1;
	g.fill = GridBagConstraints.HORIZONTAL;
	g.weightx = 1;
	final TextField tu = new TextField(30);
	final TextField tp = new TextField(30);
	tp.setEchoChar('*');
	g.gridy = 2;
	d.add(tu, g);
	g.gridy = 3;
	d.add(tp, g);
	g.gridy = 4;
	Panel p = new Panel(new FlowLayout());
	g.gridx = 0;
	g.gridwidth = 2;
	final Button ok = new Button("OK");
	final Button cancel = new Button("Cancel");
	p.add(ok);
	p.add(cancel);
	d.add(p, g);
	ActionListener al = new ActionListener () {
	    public void actionPerformed (ActionEvent e) {
	if( e.getSource()==cancel ) {
	    tu.setText(null);
	    tp.setText(null);
	}
	d.dispose();
	    }
	};
	ok.addActionListener(al);
	cancel.addActionListener(al);
	d.pack();
	Dimension p1 = d.getToolkit().getScreenSize(), p2 = d.getSize();
	d.setLocation(p1.width/2-p2.width/2, p1.height/2-p2.height/2);
	d.show();
	String a = tu.getText()+":"+tp.getText();
	if( a.equals(":") )
	    return null;
	try {
	
	    return com.ibm.sslite.PKI.base64(a.getBytes("ISO8859_1"));
	// _PKI// _PKI
	} catch (Exception e) {
	    // UnsupportedEncodingException - ISO8859-1 should be always there
	    return null;
	}*/
	Base64 encoder = new Base64();
	String pass = encoder.base64Encode(username + ":" + password);
	return pass;
}
public static void main(String[] args) 
{
	System.out.println("This is not an application and is for reference only. Please view the source code for an example of Proxy Authentication through HTTPS.");
}
	// This method is called by HTTPS protccol handler
	// when proxy authentication is detected.
	public String proxyAuthString (URL u, String scheme, int retries) {
	// u:       URL of the proxy (basically host/port are the intersting parts)
	// scheme:  the authentication scheme (in 99.99% of all cases: "basic")
	// retries: the nth retry of the user to "guess" the password (0=first attempt, 1=1st retry, ...)

	// Call common handler for proxy authentication & server authentication
	// Return authentication string or null (user did cancel dialog - no information available)
	return authString(u, scheme, null, retries);
	}
	// This method is called by HTTPS protccol handler
	// when proxy/server authentication is detected.
	public boolean schemeSupported (String scheme) {
	return scheme.toLowerCase().equals("basic");
	}
}
