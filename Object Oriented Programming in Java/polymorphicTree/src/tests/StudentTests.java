package tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import junit.framework.TestCase;
import tree.PlaceKeysValuesInArrayLists;
import tree.PolymorphicBST;

public class StudentTests extends TestCase {
	

	@Test
	public void test1() {
		PolymorphicBST<Integer,String> ptree = new PolymorphicBST<Integer,String>();
		ptree.put(21, "Twenty-One");
		ptree.put(30, "Thirty");
		ptree.put(17, "Seventeen");
		ptree.put(8, "Eight");
		ptree.put(18, "Eighteen");
		ptree.put(31, "Thirty-One");
		ptree.put(6, "Six");
		ptree.put(9, "Nine");
		ptree.remove(8);
		
		PlaceKeysValuesInArrayLists<Integer, String> task = new PlaceKeysValuesInArrayLists<Integer, String>();
		ptree.inorderTraversal(task);
		
		System.out.print(task.getKeys().toString());
		
		
		
		
	}
}