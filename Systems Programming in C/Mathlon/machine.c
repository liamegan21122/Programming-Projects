#include <stdio.h>
#include "machine.h"

/* (c) Liam Egan, 2021. This project implements a hypothetical CPU named 
 * Mathlon. The CPU reads a 32-bit instruction called N2 and performs basic
 * operations based on the individual bits of the instruction. The functions 
 * below primarily processes hexadecimal N2 instructions and converts it to 
 * human readable assembly code. The 32-bit N2 instruction is read as follows:
 * The first 5-bits are the opcode instruction, the next 3-bits are the opcode
 * extension, the next 3-bits are the first register. The next 3-bits are the 
 * second register, the next 3-bits are the third register, and the remaining
 * 15-bits are the memory address.
 */

/* Declare check_input */
static int check_input(Wrd instruction);

/* This function reads a Wrd instruction and prints its Assembly code output.
 * The function will only print assembly code output if the N2 instruction
 * read is valid. If the instruction is valid, the function returns 1, if the
 * instruction is invalid the function returns 0. 
 */
unsigned short print_instruction(Wrd instruction){
  
  /* Get N2 instructions */
  int opcode = (instruction >> 27) & 0x1f;
  int extension = (instruction >> 24) & 7;
  int reg1 = (instruction >> 21) & 7;
  int reg2 = (instruction >> 18) & 7;
  int reg3 = (instruction >> 15) & 7;
  int memory = instruction & 0x7fff;

  /* Calls check_input to see if instruction is valid */
  if (!check_input(instruction)){
    return 0;
  }

  /* Prints assembly code */
  if (opcode == PLUS){
    printf("%s\t %c%d %c%d %c%d", "plus", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == MINUS){
    printf("%s\t %c%d %c%d %c%d ", "minus", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == TIMES){
    printf("%s\t %c%d %c%d %c%d ", "times", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == DIV){
    printf("%s\t %c%d %c%d %c%d ", "div", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == MOD){
    printf("%s\t %c%d %c%d %c%d ", "mod", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == NEG){
    printf("%s\t %c%d %c%d ", "neg", 'R', reg1, 'R', reg2);
  }

  if (opcode == ABS){
    printf("%s\t %c%d %c%d ", "abs", 'R', reg1, 'R', reg2);
  }

  if (opcode == SHL){
    printf("%s\t %c%d %c%d %c%d ", "shl", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == SHR){
    printf("%s\t %c%d %c%d %c%d ", "shr", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == BAND){
    printf("%s\t %c%d %c%d %c%d ", "band", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == BOR){
    printf("%s\t %c%d %c%d %c%d ", "bor", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == BXOR){
    printf("%s\t %c%d %c%d %c%d ", "bxor", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == BNEG){
    printf("%s\t %c%d %c%d ", "bneg", 'R', reg1, 'R', reg2);
  }

  if (opcode == AND){
    printf("%s\t %c%d %c%d %c%d ", "and", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == OR){
    printf("%s\t %c%d %c%d %c%d ", "or", 'R', reg1, 'R', reg2, 'R', reg3);
  }

  if (opcode == NOT){
    printf("%s\t %c%d %c%d ", "not", 'R', reg1, 'R', reg2);
  }
  
  if (opcode == EQ){
    printf("%s\t %c%d %c%d %05d ", "eq", 'R', reg1, 'R', reg2, memory);
  }

  if (opcode == NEG){
    printf("%s\t %c%d %c%d %05d ", "neq", 'R', reg1, 'R', reg2, memory);
  }
  
  if (opcode == LE){
    printf("%s\t %c%d %c%d %05d ", "le", 'R', reg1, 'R', reg2, memory);
  }

  if (opcode == LT){
    printf("%s\t %c%d %c%d %05d ", "lt", 'R', reg1, 'R', reg2, memory);
  }

  if (opcode == GE){
    printf("%s\t %c%d %c%d %05d ", "ge", 'R', reg1, 'R', reg2, memory);
  }

  if (opcode == GT){
    printf("%s\t %c%d %c%d %05d ", "gt", 'R', reg1, 'R', reg2, memory);
  }

  if (opcode == MOVE){
    printf("%s\t %c%d %c%d", "move", 'R', reg1, 'R', reg2);
  }

  if (opcode == LW){
    printf("%s\t %c%d %05d ", "lw", 'R', reg1, memory);
  }

  if (opcode == SW){
    printf("%s\t %c%d %05d ", "sw", 'R', reg1, memory );
  }

  if (opcode == LI){
    printf("%s\t %c%d %05d ", "li", 'R', reg1, memory);
  }

  if (opcode == SYS){
    if (extension < 4){
      printf("%s\t %d %c%d ", "sys", extension, 'R', reg1);
      return 1;
    }

    printf("%s\t %d ", "sys", extension);
  }

  return 1;
}

/* This function reads an array of N2 instructions and prints each instruction's
 * assembly code output. The function also checks if each input from the array
 * is a valid instruction, if the instruction is invalid, then the bad_instr
 * pointer is dereferenced to the corresponding N2 instruction. 
 */
unsigned short disassemble(const Wrd program[], unsigned short num_instrs, 
			   unsigned short *const bad_instr) {
  int i = 0, location = 0;

  /* Checks for base case error */
  if (program == NULL || bad_instr == NULL || num_instrs > NUM_WORDS){
    return 0;
  }

  /* Iterates through each N2 instruction stored in the array
   * and calles check_input to see if the instruction is valid
   */
  for (i = 0; i < num_instrs; i++){

    if (!check_input(program[i])){
      *bad_instr = program[i];
      return 0;
    }

    /* If true print output */
    printf("%04x%c ",location,':');
    print_instruction(program[i]);
    printf("\n");
    location += 4;
  }

  return 1;
}

/* This function takes an array of N2 instructions and register number and 
 * checks for the first instance that the register was modified. if a N2 
 * instruction is found that modifies the register passed, then the function 
 * returns the index value of the array. If no instruction was found, then 
 * the function returns -1. 
 */
short where_set(const Wrd program[], unsigned short num_words, 
		unsigned short reg_nbr){
  int i = 0;

  /* Base error cases */
  if (program == NULL || num_words > NUM_WORDS){
    return -1;
  }
    
  /* Iterate through array and check for register number
   * if the register is modified in the current array index
   * return array index. 
   */
  for (i = 0; i < num_words; i++){
    /* Get N2 instructions */
    int opcode = (program[i] >> 27) & 0x1f;
    int extension = (program[i] >> 24) & 7;
    int reg1 = (program[i] >> 21) & 7;
    
    /* Checks if register matches */
    if (reg1 == reg_nbr){
      if (opcode < EQ || opcode == MOVE || opcode == LW || opcode == LI){
	return i;
      }
      
      /* Checks for SYS opcode and its R1 modification excption */
      if (opcode == SYS){

	if (extension == 0 || extension == 2){
	  return i;
	}

      }
    }
  }
    
  return -1;
  
}

/* This function itertates through an array of N2 instruction and checks
 * if the  instructions represent a valid program. If the the program is valid
 * the function will return 1, if the program is invalid the function will 
 * return 0. If an invalid instruction is found, then the bad_instr pointer
 * gets dereferenced to it. 
 */
unsigned short is_safe(const Wrd program[], unsigned short pgm_size, 
		       unsigned short *const bad_instr){
  int i = 0;

  /* Check base error cases */
  if (program == NULL || bad_instr == NULL || pgm_size > NUM_WORDS){
    return 0;
  }
  
  /* Iterates through program array and passes each instruction through
   * check_input.
   */
  for (i = 0; i < pgm_size; i++){

    if (!check_input(program[i])){
      *bad_instr = program[i];
      return 0;
    }

  }
  return 1; 
}

/* This is a private helper function that checks if each N2 instruction is valid
 * Since the criteria for a valid instruction is fairly indepth, I chose to
 * create this helper function to avoid unesscessary code duplication. 
 */
static int check_input(Wrd instruction){

  /* Get N2 instructions */
  int opcode = (instruction >> 27) & 0x1f;
  int extension = (instruction >> 24) & 7;
  int reg1 = (instruction >> 21) & 7;
  int reg2 = (instruction >> 18) & 7;
  int reg3 = (instruction >> 15) & 7;
  int memory = instruction & 0x7fff;

  /* if opcode is greater than 26 then its an invalid instruction */
  if (opcode > SYS){
    return 0;
  }

  /* A register can only exist from 0...6 */
  if (reg1 > 6 || reg2 > 6 || reg3 > 6) {
    return 0;
  }

  /* Check if memory address is a valid multiple of 4 */
  if (opcode == EQ || opcode == NEQ || opcode == LE || opcode == LT ||
      opcode == GE || opcode == GT || opcode == LW){

    if (memory % 4 != 0){
      return 0;
    }

  }

  /* Check if the unmodifiable program counter R6 is attempting to be modified*/
  if (reg1 == 6){
    if (opcode < EQ || opcode == MOVE || opcode == LW || opcode == LI || 
	opcode == SYS){
      
      /* If opcode is anything but SYS */
      if (opcode != SYS){
	return 0;
      }
      
      /* If Opcode is SYS it's extension has to be 1 3 4 for R1 
       * to not be modified
       */
      if ((opcode == SYS && extension == 2) ||
	  (opcode == SYS && extension == 0)){
	return 0;
      }

    }
  }
	
  /* Check if opcode is SYS and has a invalid extension */
  if ((opcode == SYS && extension > 4) || (opcode == SYS && extension < 0)){
    return 0;
  }

  return 1;
}

