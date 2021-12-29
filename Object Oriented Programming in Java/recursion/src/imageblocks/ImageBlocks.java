
package imageblocks;

import java.awt.Color;
import java.util.ArrayList;

import utils.Picture;

public class ImageBlocks {
    static Color BLACK = new Color(0,0,0);
    static Color WHITE = new Color(255,255,255);                
    private int height;
    private int width;
    boolean [][] visited;
    public int [][] binaryImage;
    Picture pic;
    
    public ImageBlocks(Picture pic) {
    	this.pic = pic;
    	height = pic.height();
    	width = pic.width();
    	this.binaryImage = new int[width][height];
    	buildBinaryImage();
    }
    
    
    private boolean isBlack(int x,int y){
        return pic.get(x,y).equals(BLACK);
    }
    private boolean isWhite(int x,int y){
        return pic.get(x,y).equals(WHITE);
    }
   
    private void buildBinaryImage(){
    	for (int i = 0; i < width; i++) {
    		for (int j = 0; j < height; j++) {
    			if (pic.get(i, j).equals(WHITE)) {
    				binaryImage[i][j] = 0;
    			}
    			else {
    				binaryImage[i][j] = 1;
    			}
    		}
    	}
    }
    
    private void printBinaryImage(int[][] binaryImage) {
    	for (int i = 0; i < binaryImage.length; i++) {
    		for(int j = 0; j < binaryImage[0].length; j++) {
    			System.out.print(binaryImage[i][j]);
    		}
    		System.out.println();
    	}
    }
    
    /**
     * count the number of image blocks in the given image
     * Counts the number of connected blocks in the binary digital image
     * @return number of black blocks
     */
    public int countConnectedBlocks(){
    	this.visited = new boolean[binaryImage.length][binaryImage[0].length];
    	int shapeCounter = 0;
    	for (int i = 0; i < binaryImage.length; i++) {
    		for (int j = 0; j < binaryImage[0].length; j++) {
    			if (binaryImage[i][j] != 0 && !visited[i][j]) {
    				shapeCounter++;
    				countConnectedBlocks(binaryImage, visited, i, j);
    			}
    		}
    	}
    	return shapeCounter;
	}
    
    private void countConnectedBlocks(int[][] binaryImage, boolean[][] visited, int row, int col) {
    	if (row >= 0 && row < binaryImage.length && 
    		col >= 0 && col < binaryImage[0].length && 
    		binaryImage[row][col]!=0 && !visited[row][col]) {
    		
    		visited[row][col] = true;
    		countConnectedBlocks(binaryImage, visited, row, col + 1);
    		countConnectedBlocks(binaryImage, visited, row - 1, col);
    		countConnectedBlocks(binaryImage, visited, row, col - 1);
    		countConnectedBlocks(binaryImage, visited, row + 1, col);
    		countConnectedBlocks(binaryImage, visited, row - 1, col - 1);
    		countConnectedBlocks(binaryImage, visited, row - 1, col + 1);
    		countConnectedBlocks(binaryImage, visited, row + 1, col - 1);
    		countConnectedBlocks(binaryImage, visited, row + 1, col + 1);
    	}
    }
    
    /**
     * Removes all neighboring black pixels of the provided pixel (x,y)
     * @param x
     * @param y
     * @return updated picture
     */
    public Picture delete(int x, int y) {
    	this.visited = new boolean[binaryImage.length][binaryImage[0].length];
    	for (int i = 0; i < binaryImage.length; i++) {
    		for(int j = 0; j < binaryImage[0].length; j++) {
    			if (i == x && j == y) {
    				countConnectedBlocks(binaryImage, visited, i, j);
    			}
    		}
    	}
    	for (int i = 0; i < binaryImage.length; i++) {
    		for (int j = 0; j < binaryImage[0].length; j++) {
    			if (visited[i][j] == true) {
    				pic.set(i, j, WHITE);
    				binaryImage[i][j] = 0;
    			}
    		}
    	}
    	return pic;
	}
    
    /**
     * Crops an image by setting all the pixels outside the provided
     * indices to the color white
     * delete everything not inside the bounds of the parameters (inclusive)
     * @param row_start
     * @param col_start
     * @param row_end
     * @param col_end
     * @return updated picture
     */
    public Picture crop(int x_start, int x_end, int y_start, int y_end) {
    	return crop(x_start, x_end, y_start, y_end, 0);
	}
    
    private Picture crop(int x_start, int x_end, int y_start, int y_end, int row) {
    	if (row == this.binaryImage.length) {
    		return pic;
    	}
    	crop(x_start,  x_end,  y_start, y_end, row, 0);
    	return crop(x_start,  x_end,  y_start, y_end, row + 1);
    }
    
    private boolean crop(int x_start, int x_end, int y_start, int y_end, int row, int col){
    	if (col == this.binaryImage[0].length) {
    		return true;
    	}
    	if (row < x_start || row > x_end) {
    		pic.set(row, col, WHITE);
    		binaryImage[row][col] = 0;
    	}
    	if (col < y_start || col > y_end) {
    		pic.set(row, col, WHITE);
    		binaryImage[row][col] = 0;
    	}
    	return crop(x_start, x_end, y_start, y_end, row, col + 1);
    }
    
    public static void main(String[] args) {
        
        String fileName = "images/14.png";
        Picture p = new Picture(fileName);
        ImageBlocks block = new ImageBlocks(p);
        try{
            int c1 = block.countConnectedBlocks();
            block.delete(4, 8);
            int c2 = block.countConnectedBlocks();
            p = block.crop(0, 90, 0, 90);
            int c3 = block.countConnectedBlocks();
            System.out.println("Number of connected blocks="+c1);
            System.out.println("Number of connected blocks after delete="+c2);
            System.out.println("Number of connected blocks after crop="+c3);
        }catch(Exception ex){
            System.out.println(ex.getMessage());
        }
    }
}
