package tree;

import java.util.Collection;

/**
 * This class represents a non-empty search tree. An instance of this class
 * should contain:
 * <ul>
 * <li>A key
 * <li>A value (that the key maps to)
 * <li>A reference to a left Tree that contains key:value pairs such that the
 * keys in the left Tree are less than the key stored in this tree node.
 * <li>A reference to a right Tree that contains key:value pairs such that the
 * keys in the right Tree are greater than the key stored in this tree node.
 * </ul>
 *  
 */
 public class NonEmptyTree<K extends Comparable<K>, V> implements Tree<K, V> {

	/* Provide whatever instance variables you need */
	private Tree<K,V> left, right;
	private K key;
	private V value;
	
	/**
	 * Only constructor we need.
	 * @param key
	 * @param value
	 * @param left
	 * @param right
 */
	public NonEmptyTree(K key, V value, Tree<K,V> left, Tree<K,V> right) { 
		this.key = key;
		this.value = value;
		this.left = left;
		this.right = right;
	}

	public V search(K key) {
		if (key.compareTo(this.key) == 0) {
			return this.value;
		}
		if (key.compareTo(this.key) > 0) {
			return this.right.search(key);
		}
		else {
			return this.left.search(key);
		}
	}
	
	public NonEmptyTree<K, V> insert(K key, V value) {
		if (key.compareTo(this.key) == 0) {
			this.value = value;
		}
		if (key.compareTo(this.key) < 0) {
			this.left = this.left.insert(key, value);
		}
		if (key.compareTo(this.key) > 0) {
			this.right = this.right.insert(key, value);
		}
		return this;
		
	}
	
	public Tree<K, V> delete(K key) {
		if (key.compareTo(this.key) == 0) {
			try {
				this.key = this.left.max();
				this.value = this.left.search(this.left.max());
				this.left = left.delete(this.left.max());
			}
			catch(TreeIsEmptyException e) {
				try {
					this.key = this.right.min();
					this.value = this.right.search(this.right.min());
					this.right = this.right.delete(this.right.min());
				}
				catch(TreeIsEmptyException e2) {
					return EmptyTree.getInstance();
				}
			}
		}
		if (key.compareTo(this.key) > 0) {
			this.right = this.right.delete(key);
		}
		if (key.compareTo(this.key) < 0) {
			this.left = this.left.delete(key);
		}
		return this;
	}

	public K max() {
		try {
			return right.max();
		} catch (TreeIsEmptyException e) {
			return key;
		}
	}

	public K min() {
		try {
			return this.left.min();
		}
		catch (TreeIsEmptyException e) {
			return key;
		}
	}

	public int size() {
		return right.size() + left.size() + 1;
	}

	public void addKeysToCollection(Collection<K> c) {
		left.addKeysToCollection(c);
		c.add(key);
		right.addKeysToCollection(c);
	}
	
	public Tree<K,V> subTree(K fromKey, K toKey) {
		if (fromKey.compareTo(this.key) > 0) {
			return this.right.subTree(fromKey, toKey);
		}
		if (toKey.compareTo(this.key) < 0) {
			return this.left.subTree(fromKey, toKey);
		}
		else {
			NonEmptyTree<K, V> subTree = new NonEmptyTree<K, V>(this.key, this.value, left.subTree(fromKey, toKey), this.right.subTree(fromKey, toKey)); 
			return subTree;
		}
	}

	public int height() {
		if (left.height() > right.height()) {
			return left.height() + 1;
		}
		if (left.height() < right.height()) {
			return right.height() + 1;
		}
		if (left.height() == right.height()) {
			return left.height() + 1;
		}
		return 0;
	}
	
	public void inorderTraversal(TraversalTask<K,V> p) {
		left.inorderTraversal(p);
		
		p.performTask(key, value);
		
		right.inorderTraversal(p);
	}
	
	public void rightRootLeftTraversal(TraversalTask<K,V> p) {
		right.rightRootLeftTraversal(p);
		
		p.performTask(key, value);
		
		left.rightRootLeftTraversal(p);
	}
	
}
