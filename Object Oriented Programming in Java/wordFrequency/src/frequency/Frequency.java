/*
* This class counts the word frequency
 */
package frequency;

import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * @author UMD CS
 * CMSC132 Summer 2017
 */
public class Frequency<E extends Comparable> implements Iterable<E>{
    private Node first;	//starting node
    private Node parent;	//parent of currently processed node
    private int N;	//number of words
    
    /**
     * Linked List Node
     */
    private class Node {
    	private E key;
    	private int count;
        private Node next;
        
        /**
         * 	Constructor
         */
        Node(E e){
           key = e;
           count = 1;
           next = null;
        }
        
        /**
         * 	Constructor
         */
        Node(E e, Node r){
            key = e;
            count = 1;
            next = r;
         }
        
        @Override 
        public String toString(){
        	return "("+key +","+count+")";
        }
		
    }

   /**
    * Inserts a word into linked list
    * @param key to be insterted 
    * @return true if the key is inserted successfully.
    */
    public boolean insert(E key) {
    	//Instantiates a new node with the given key parameter 
    	Node newNode = new Node(key, null);
    	//Conditional that checks if a node exists, if not set as beginning node
    	if (this.N == 0) {
    		first = new Node(key, first);
    		parent = new Node(key, first);
    		this.N++;
    		return true;
    	}
    	//Instantiates a current node as first for iteration
    	Node current = first;
    	//Instantiates a new node with the key parameter for comparison to current 
    	Node currentNode = find(key);
    	boolean flag = true;
    	while (current != null) {
    		//Conditional that checks if the node key parameter already exists
    		if (currentNode != null){
    			
    			//Adds +1 to node count 
    			if (flag) {
    				currentNode.count++;
    				flag = false;
    			}
    			//Compares currentNode count to current count if count is greater than current, swap positions.
    			//This comparison moves in a sequential order, if the conditional is true it returns true.
    			//If this conditional is true it swaps the currentNode with current node from while loop iteration.
    			if (currentNode.count > current.count) {
    				remove(currentNode.key);
    				insertAfter(current, currentNode);
    				remove(current.key);
    				insertAfter(currentNode, current);
    				return true;
    				
    			}
    			//This Conditional compares in the same manner as the previous, since this conditional checks for alphabetical order
    			//It compares the starting chars unicode points value
    			if (Character.toLowerCase(currentNode.toString().charAt(1)) < Character.toLowerCase(current.toString().charAt(1)) 
    					&& currentNode.count == current.count ) {
    				remove(currentNode.key);
    				insertAfter(current, currentNode);
    				remove(current.key);
    				insertAfter(currentNode, current);
    				return true;
    			}
    			
    			//If the next node is null return true
    			if (current.next == null) {
    				return true;
    			}
    			
    		}
    		
    		//Adjust values for iteration
    		this.parent = current;
        	current = current.next;
    	}
    	//Else create a new node at end of list
    	this.parent.next = newNode;
    	this.N++;
    	return true;
    }
  //switch to private
   /**
    * removes the nodes with given key
    * @param key: 
    * @return the deleted node
    */
    public Node remove(E key){
    	if (key == null) {
    		return null;
    	}
    	if (this.first.key.toString().equals(key.toString())) {
    		this.first = first.next;
    		return this.first;
    	}
    	Node parent = this.first;
    	Node current = first.next;
    	while(current != null) {
    		if (current.key.toString().equals(key.toString())) {
    			parent.next = current.next;
    			return current;
    		}
    		parent = current;
    		current = current.next;
    	}
    	return null;
    }

  //switch to private
	/**
     * Inserts a node into correct location in the linked list
     * @param r is the node to be inserted
     * @return true if successful
     */
    public void insertAfter(Node previous, Node newNode){
    	
    	newNode.next = previous.next;
    	
    	previous.next = newNode;
    	
    	return;
    	
	}
    
 
    
    //switch to private
    /**
     * @param k is the key to be searched for
     * @return the node that has the word as its key
     */
    public Node find(E k){
		Node current = this.first;
		while (current != null) {
			if (current.key.toString().equals(k.toString())) {
				return current;
			}
			current = current.next;
		}
		return null;
		
	}
    
    /**
     * 
     * @param key is the key to be searched for
     * @return frequency of the key. Returns -1 if key does not exist
     * 
     */
    public int getCount(E key){
		Node current = this.first;
		while(current != null) {
			if (current.key.toString().equals(key.toString())) {
				return current.count;
			}
			current = current.next;
		}
		return 0;
	}
    
    /**
     * Returns the first n words and count
     * @param n number of words to be returned
     * @return first n words in (word, count) format
     */
    public String getWords(int n){
    	if (n == 0) {
    		return null;
    	}
    	if (n > this.N) {
    		n = this.N;
    	}
		String ans = "";
		Node current = this.first;
		int i = 0;
		while(i < n) {
			ans += current.toString();
			ans += " ";
			i++;
			current = current.next;
		}
		return ans;
	}
    
    /**
     * Frequency List iterator
     */
    @Override
    public Iterator<E> iterator() {
        return new FreqIterator(this.first);
    }
    
    /**
     * 
     * Frequency List iterator class
     *
     */
    private class FreqIterator implements Iterator<E>{
    	
    	private Node current = null;
    	
    	public FreqIterator(Node first) {
            this.current = first;
        }
    
    	@Override
    	public boolean hasNext() {
    	  return this.current != null;
    	}
    	
    	@Override
    	public E next() {
    		if (!hasNext()) {
    			return null;
    		}
    		E key = this.current.key;
    		this.current = this.current.next;
    		return key;
		
    	}
      
    }
}
    
