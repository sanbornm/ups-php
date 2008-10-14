import sun.misc.*;
import java.io.*;


public class Base64Decode {

    public static void main(String[] args) {
	
	if (args.length >= 2) {
	    try {
		InputStream is = new FileInputStream(args[0]);
		OutputStream os = new FileOutputStream(args[1]);
		BASE64Decoder b64dc = new BASE64Decoder();
		b64dc.decodeBuffer(is, os);
	    }
	    catch (IOException e) {
		System.err.println(e);
	    }
	}
	else {
	    System.out.println("Need 2 args");
	}
    } // end if
    
}  // end main