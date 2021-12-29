
package sixdegrees;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Stack;
import java.util.logging.Level;
import java.util.logging.Logger;

public class KevinBaconNumber {
    
    SymbolGraph sg;
    
    public KevinBaconNumber(String filename, String delimiter) throws FileNotFoundException, IOException {
        sg = new SymbolGraph(filename, delimiter);
        
    }
    public String list(String source){
        Bag<String> bg = sg.list(source);
        StringBuilder str = new StringBuilder();
        if(bg != null){
            for(String s:bg){
            	str.append(s);
                System.out.println(s);
            }
        }
        return str.toString();
    }
    public String neighbors(String source){
        Bag<String> bg = sg.neighbors(source);
        List<String> sortedList = new ArrayList();
        for (String s: bg) {
            sortedList.add(s);
        }
        Collections.sort(sortedList);
        
        StringBuilder str = new StringBuilder();
        if(bg != null){
            for(String s:sortedList){
            	str.append("[");
            	str.append(s);
            	str.append("],");
                System.out.println(s);
            }
        }
        return str.toString();
    }
    public Integer path(String source, String sink){  
        Graph G = sg.G();
        if (!sg.contains(source)) {
            System.out.println(source + " not in database.");
            return null;
        }

        int s = sg.index(source);
        BreadthFirstPaths bfs = new BreadthFirstPaths(G, s);
        
        int count = 0;
        
        if (sg.contains(sink)) {
        	 for (int v : bfs.pathTo(sg.index(sink))) {
             	count++;
        	 }
        }
        
        int path = 0;
        while(path < count) {
        	if (sg.contains(sink)) {
        		if (bfs.hasPathTo(sg.index(sink))) {
        			for (int v : bfs.pathTo(sg.index(sink))) {
        				path++;
        				System.out.print(sg.name(v));
        			}
        		}
        			System.out.print("Not connected");
        			break;
        	}
        		System.out.print("Not in database");
        		break;
        		
        }
        return path;
    }
    
    public static void main(String[] args) {
        
      String filename = "cast.all.txt";
      String delimiter = "/";
      KevinBaconNumber kv;
        try {
            kv = new KevinBaconNumber(filename, delimiter);
            String from = "Bacon, Kevin";
            String to;
            
            while(true){
                int select = 0;
                while(!(select >= 1 && select <=5)){
                    System.out.println("========================================");
                    System.out.println("1.Degree of separation from Kevin Bacon:");
                    System.out.println("2.Degree of separation between any two actors/actrsses:");
                    System.out.println("3.Search actor/actress/movie:");
                    System.out.println("4.List cast of a movie or movies of an actor/actress:");
                    System.out.println("5. Exit");
                    select = InputHelper.getIntegerInput("Select:");
                }
                Integer pathLength = 0;
                switch(select){
                    case 1:
                        to = InputHelper.getStringInput("Enter the name (lastname, firstname): ");
                        pathLength = kv.path(from, to);  
                        break;
                    case 2:
                        from = InputHelper.getStringInput("Enter the name (lastname, firstname): ");
                        to = InputHelper.getStringInput("Enter the name (lastname, firstname): ");
                        pathLength  = kv.path(from, to);  
                        break;
                    case 3:
                        to = InputHelper.getStringInput("Enter the name:");
                        kv.list(to);
                        break;
                    case 4:
                        to = InputHelper.getStringInput("Enter the name:");
                        kv.neighbors(to);  
                        break;
                    case 5:
                        return;
                }
                System.out.println("");
            }     
        } catch (FileNotFoundException ex) {
            System.err.println("Input File Not Found.");
        } catch (IOException ex) {
            System.err.println("Input File Read Error.");
        } catch (NumberFormatException ex) {
        	System.err.println("Invalid Input.");
        }
    }
}
