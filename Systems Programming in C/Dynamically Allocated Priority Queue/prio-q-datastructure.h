#include <stdio.h>

/* (c) Liam Egan, 2020
 * UID: 115889972
 * This is the Prio_que struct that defines the fields
 * of a Prio_que variable. Note that the Prio_que
 * and node defintion share the same struct because
 * they are the same. 
 */
typedef struct node{
  int priority;
  char* element; 
  struct node *next;
} Prio_que;
