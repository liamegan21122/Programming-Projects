#include <stdio.h>
/* (c) Liam Egan, 2021
 * This program is designed as an auxillary program for warnlines.c. What this
 *  program does is that it the output from the warnlines.c program and 
 * condenses it's results.What this means is that this programs prints 
 * the line numbers that exceed 80. If there are no lines that exceed 80, 
 * the program prints a newline character. 
 */

int main(void) {
  char c;
  int line_number = 0, i = 0, lines_over_80 = 0, skip_line = 1;
  char characters[1000];
  int lines[100000];
  
  /* Open scanner */
  scanf("%c", &c);

  /* Iterate through characters until EOF */
  while(!feof(stdin)){
    
    /* Check if end of line has been reached */
    if (c == '\n'){

      /* Checks if input line needs to be skipped */
      if (skip_line) {
	line_number++;
      }
      
      /* Since line has already been skipped we can set back to 1 */
      if(skip_line == 0){
	skip_line = 1;
      }
      
      /* Check if line exceeds 80 characters */
      if (characters[0] == '*'){
	lines[lines_over_80] = line_number;
	lines_over_80++;
	skip_line = 0;
      }

      i = 0;

    }

    /* Add every non newline character to array */
    if (c != '\n'){
      characters[i] = c;
      i++;
    }
    
    /* Close scanner */
    scanf("%c", &c);

  }

  /* Iterate through lines and print the lines that exceed 80 */
  if (lines_over_80 > 0){
    for(i = 0; i < lines_over_80; i++){

      if (i == lines_over_80 - 1){
	printf("%d\n", lines[i]);
	return 0;
      }

      printf("%d%c", lines[i], ' ');

    }
  }
  
  printf("\n");

  return 0;
}

