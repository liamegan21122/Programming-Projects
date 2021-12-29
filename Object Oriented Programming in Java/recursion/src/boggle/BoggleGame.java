package boggle;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

import utils.LetterGrid;

public class BoggleGame {
	
	/**
	 * The grid that contains all the letters. @see boggle.LetterGrid
	 */
	LetterGrid grid;
	
	/**
	 * The stack that stores the path when you search the word path
	 */
	Stack<String> path;
	Stack<String> temp;
	Stack<String> history;
	
	/**
	 * A boolean array to mark any location (row,col) as visited
	 */
	public boolean[][] visited;
	
	public char[][] charGrid;
	
	ArrayList<int[]> adjacentCoordinates;
	

	
	public BoggleGame(LetterGrid g) {
		grid = g;
	}
	
	/**
	 * This is a supporting method that converts grid to
	 * a 2d char array. Uses charGrid instance. 
	 * @return void
	 */
	private void buildCharGrid() {
		for (int i = 0; i < charGrid.length; i++) {
			for (int j = 0; j < charGrid[0].length; j++) {
				charGrid[i][j] = grid.getLetter(i, j);
			}
		}
	}
	
	/**
	 * A recursive helper method for find word
	 * @param row
	 * @param col
	 * @param index
	 * @param word
	 * @param visited
	 * @return true if "word" can be found in grid, false otherwise
	 */
	private boolean findWordSupport(char[][] charGrid, boolean[][]visited, String word, int index, int row, int col, ArrayList<int[]> adjcentCoordinates) {
		if (index == word.length()) {
			return true;
		}
		if (row == charGrid.length) {
			return false;
		}
		if (col == charGrid[0].length) {
			return findWordSupport(charGrid, visited, word, index, row + 1, col = 0, adjcentCoordinates);
		}
		if (charGrid[row][col] == word.charAt(index) && visited[row][col] != true) {
			if (boggleCheck(charGrid, visited, word, index, row, col, adjcentCoordinates)) {
				return true;
			}
			else {
				path.clear();
			}
		}
		return findWordSupport(charGrid, visited, word, index, row, col + 1, adjcentCoordinates);
	}
	
	private ArrayList<Character> findWordSupport2(char[][]charGrid, boolean[][]visited, String word, int index, int row, int col, ArrayList<int[]> adjcentCoordinates) {
		char c = word.charAt(index);
		ArrayList<Character> adjcent = new ArrayList<>();
		this.adjacentCoordinates = new ArrayList<>();
		if (charGrid[row][col] == c) {
			if ( row - 1 > -1 && col - 1 > -1) {
				adjcent.add(charGrid[row - 1][col - 1]);
				int[] temp = new int[2];
				temp[0] = row - 1;
				temp[1] = col - 1;
				adjacentCoordinates.add(temp);
			}
			if (row - 1 > -1) {
				adjcent.add(charGrid[row - 1][col]);
				int[] temp = new int[2];
				temp[0] = row - 1;
				temp[1] = col;
				adjacentCoordinates.add(temp);
			}
			if (row - 1 > -1 && col + 1 < charGrid[0].length) {
				adjcent.add(charGrid[row -1][col +1]);
				int[] temp = new int[2];
				temp[0] = row - 1;
				temp[1] = col + 1;
				adjacentCoordinates.add(temp);
			}
			if (col - 1 > -1) {
				adjcent.add(charGrid[row][col - 1]);
				int[] temp = new int[2];
				temp[0] = row;
				temp[1] = col - 1;
				adjacentCoordinates.add(temp);
			}
			if (col + 1 < charGrid[0].length) {
				adjcent.add(charGrid[row][col + 1]);
				int[] temp = new int[2];
				temp[0] = row;
				temp[1] = col + 1;
				adjacentCoordinates.add(temp);
			}
			if (row + 1 < charGrid.length && col - 1 > -1) {
				adjcent.add(charGrid[row + 1][col -1]);
				int[] temp = new int[2];
				temp[0] = row + 1;
				temp[1] = col - 1;
				adjacentCoordinates.add(temp);
			}
			if (row +1 < charGrid.length) {
				adjcent.add(charGrid[row + 1][col]);
				int[] temp = new int[2];
				temp[0] = row + 1;
				temp[1] = col;
				adjacentCoordinates.add(temp);
			}
			if (row + 1 < charGrid.length && col + 1 < charGrid[0].length) {
				adjcent.add(charGrid[row + 1][col + 1]);
				int[] temp = new int[2];
				temp[0] = row + 1;
				temp[1] = col + 1;
				adjacentCoordinates.add(temp);
			}
			
		}
		return adjcent;
	}
	
	private boolean boggleCheck(char[][]charGrid, boolean[][]visited, String word, int index, int row, int col, ArrayList<int[]> adjcentCoordinates) {
		if (index == word.length() - 1) {
			return true;
		}
		if (index == 0) {
			path.push("(" + row + "," + col +")");
		}
		visited[row][col]= true;
		findWordSupport2(charGrid, visited, word, index, row, col, adjcentCoordinates);
		for (int i = 0; i < adjacentCoordinates.size(); i++) {
			for (int j = 0; j < charGrid.length; j++) {
				for (int k = 0; k < charGrid[0].length; k++) {
					if (j == adjacentCoordinates.get(i)[0] && k == adjacentCoordinates.get(i)[1] && 
						charGrid[j][k] == word.charAt(index + 1) && visited[j][k] != true) {
						path.push("(" + j + "," + k +")");
						return boggleCheck(charGrid, visited, word, index + 1, j, k, adjcentCoordinates);
					}
				}
			}
		}
		return false;
		
	}
	
	
	
	/**
	 * implement your method here (you may write helper method)
	 * @param word
	 * @return true if "word" can be found in grid, false otherwise
	 */
	public boolean findWord(String word) {
		//Initialize a new visited grid and path Stack
		
		this.visited = new boolean[grid.getNumRows()][grid.getNumCols()];
		
		this.path = new Stack<String>(); 
		
		
		this.charGrid = new char[grid.getNumRows()][grid.getNumCols()];
		
		buildCharGrid();
		//Test
		//
		
		//Return supporting recursive method
		return findWordSupport(charGrid, visited, word, 0, 0, 0, this.adjacentCoordinates);
	}
	
	/**
	 * @param word
	 * @return the path (cell index) of each letter
	 */
	public String findWordPath(String word) {
		//Initialize a new visited grid and path Stack
		this.path = new Stack<String>(); 
		this.visited = new boolean[grid.getNumRows()][grid.getNumCols()];
		this.charGrid = new char[grid.getNumRows()][grid.getNumCols()];
		buildCharGrid();
		//Call supporting method
		findWordSupport(charGrid, visited, word, 0, 0, 0, this.adjacentCoordinates);
		return findWordPath(path, "");
	}
	
	/**
	 * A recursive helper method to build a path string from a stack
	 * @param path
	 * @param ans
	 * @return A string representing a word path
	 */
	private String findWordPath(Stack<String> path, String ans) {
		if (path.isEmpty()) {
			return ans;
		}
		return findWordPath(path, ans = path.pop() + ans);
	}
	
	
	/**
	 * Determines the frequency of a word on the Boggle board. For simplicity,
	 * assume palindromes count twice.
	 * @param word
	 * @return the number of occurrences of the "word" in the grid
	 */
	public int frequency(String word) {
		this.visited = new boolean[grid.getNumRows()][grid.getNumCols()];
		this.path = new Stack<>();
		this.charGrid = new char[grid.getNumRows()][grid.getNumCols()];
		buildCharGrid();
		this.history = new Stack<>();
		return frequencySearch(word);
	}
	
	private int frequencySupport(String word, int row, int col, int index) {
		
		int found = 0;
		
		if (boggleCheck(charGrid, visited, word, 0, row, col, adjacentCoordinates)){
			found++;
		}
		if (isPalindrome(word)) {
			return 2 * found;
		}
		return found;
	}
	private int frequencySearch(String word) {
		int found = 0;
		for (int i = 0; i < charGrid.length; i++) {
			for (int j = 0; j < charGrid[0].length; j++) {
				found += frequencySupport(word, i, j, 0);
			}
		}
		return found;
	}
	private boolean isPalindrome(String word) {
		String palindrome = "";
		for (int i = word.length() - 1; i > -1; i--) {
			palindrome += word.charAt(i);
		}
		if (palindrome.equals(word)) {
			return true;
		}
		return false;
	}
	
}