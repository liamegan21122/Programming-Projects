package tests;

import static org.junit.Assert.assertEquals;

import java.io.FileNotFoundException;
import java.io.IOException;

import org.junit.Test;

import sixdegrees.KevinBaconNumber;

public class StudentTests {
	
	@Test
	public void KBT() {
		String filename = "test1.txt"; 
	      String delimiter = "/";
	      KevinBaconNumber kv;
	        try {
	            kv = new KevinBaconNumber(filename, delimiter);
	            String s = kv.list("Bill");  
	        } catch (FileNotFoundException ex) {
	            System.err.println("Input File Not Found.");
	        } catch (IOException ex) {
	            System.err.println("Input File Read Error.");
	        }
	}

}
