#include <stdio.h>

/* (c) Liam Egan, 2021.
 * 
 * This program checks for good programming style by an reading input file and
 * finding lines that are over 80 characters. A maximum of 80 characters is 
 * checked per line because standard terminal window sizes typically 
 * have a maximum of 80 columns. This program scans through a file until EOF is 
 * reached, it then prints the file's contents. In order to determine which
 * specific lines exceed 80, the line's size is computed representing the number
 * of characters that exist in the line. However, the line's length represents
 * that total number of columns that the line occupies, this is necessary 
 * because something like a tab character would have a size of one, but would
 * occupy a length of 1-8 spaces. The program denotes a line that exceeds 80 by
 * printing an '*' before the line number, the specific characters that exceed 
 * 80 are denoted with a '^' directly underneath them. 
 *
 * "I pledge on my honor that I have not given or recieved help recieved any
 * unauthorized assistance on this assignment"
 * -Liam Egan
 *
 * UID:
 * 115889972
 *
 */
int main(void) {
  char c;
  int line = 0, i = 0, length = 0, size = 0; 
  char arr[1000];

  /* Open Scanner */
  scanf("%c", &c);

  /* Iterate each through chars until EOF is reached */
  while(!feof(stdin)) {

    /* Since the line ends here it can now be interpreted */
    if (c == '\n'){

      /* Increment line count */
      line++;

      /* Check if line's length is > 80 or < 80 */
      if (length <= 80){
	printf("%c%5d%s",' ', line, ": ");
      }
      
      if (length > 80){
	printf("%c%5d%s",'*', line, ": ");
      }
      
      i = 0;

      /* Print all characters and a newline */
      while(i < size){
	printf("%c", arr[i]);
	i++;
      }
     
      printf("%c", '\n');
      
      /* Prints '^' under characters > 80 */
      if (length > 80){

        printf("%89c", '^');
	
	/* Shift 88 columns over and print till length end */
	for (i = 89; i < length + 8; i++){
	  printf("%c", '^');
	
	}
	printf("\n");
      }
      
      /* Reset size and length */
      size = 0;
      length = 0;
    }
    
    /* For each character that's not '\n', add to array */
    if (c != '\n'){

      /* Check if new Tab character was found */
      if (c == '\t'){

	/* Calculate new length */
	length += ((8 - (length % 8)));
      }
      
      /* Store all chars besides '\n' in array */ 
      arr[size] = c;
      
      /* Increment size */
      size++;

      /* increment length for everything but '\t' and '\n'
      *  NOTE: This is because we've already calculated the 
      *  the tab character's size
      */
      if(c != '\t'){
	length++;
      }

    }

    /* Close Scanner */
    scanf("%c", &c);
  }
  
  return 0;
  
}
