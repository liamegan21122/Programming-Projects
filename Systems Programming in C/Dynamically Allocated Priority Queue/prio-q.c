#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "prio-q.h"
/* (c) Liam Egan, 2021
 * UID: 115889972
 * This program implements a dynamically allocated priority queue in ISO C90. 
 * A priority queue is a data structure that stores elements with an 
 * associated priority. The element with the highest priority is known as 
 * the peek and thus is typically the first element to be removed by the 
 * caller. This implementation of a priority queue does so via a singly
 * linked list. A linked list was chosen, because it's non-static size and 
 * sequential access properties allows for the caller to easily add and remove 
 * elements from the queue without excessive complexity. Another interesting 
 * characteristic about this linked list is that it uses a dummy head node. 
 * So when a new priority queue is created the dummy head is activated
 * and the caller can then proceed to enqueue and dequeue elements.  
 */


/* This function initializes the Prio_que paramter to an empty queue. 
 * Since the Prio_que variable is essentially a uninitialized node 
 * at this point. Init sets the next pointer to be Null to signal 
 * to the caller that the priority queue is empty and initilized. 
 */
void init(Prio_que *const prio_q){
  if(prio_q == NULL){
    return;
  }

  prio_q->next = NULL;
}

/* This function enqueues a new node to the the priority queue. 
 * The function should take a initialized priority queue variable,
 * a string, and a positive integer value. The function then creates
 *  a new dynamically allocated Node and adds it to the end of the 
 * linked list. It's worth noting that this function does not add nodes 
 * based on their priority values, the function will by default just 
 * add nodes to the end of the linked list so the order in which the 
 * nodes appear is the order in which they were chronologically added.
 * If the caller trys to add a node with a negative priority, a NULL 
 * priority queue, or a trys to assign a new node with a prexisting
 * priority value the function will return 0. 
 */
unsigned int enqueue(Prio_que *const prio_q, const char new_element[], 
		     unsigned int priority){
  Prio_que *curr, *new_node = NULL;

  /* Check base cases */
  if (prio_q == NULL || new_element == NULL){
    return 0;
  }

  if (priority < 0){
    return 0;
  }
  
  /* Parse to end of linked list and check for prexisting priority */
  curr = prio_q;
  
  while(curr->next != NULL){
    if (curr->priority == priority){
      return 0;
    }
    curr = curr->next;
  }

  /* Allocate entire node */
  new_node = malloc(sizeof(*new_node));
  
  /* Allocate enough memory for element string */
  new_node->element = malloc(strlen(new_element) + 1);
  strcpy(new_node->element, new_element);

  new_node->priority = priority;
  
  /* Add node to end of list */
  new_node->next = NULL;
  curr->next = new_node;
  
  return 1;
  
}

/* This function returns 1 if the priority queue is empty and zero otherwise.
 * Since the way in which the priority queue was intialized makes the dummy head
 * next point to NULL to signal the list has 0 elements. All that is checked is
 * if the dummy head's next is NULL. 
 */
unsigned int is_empty(const Prio_que prio_q){

  /* Check if empty */
  if (prio_q.next == NULL){
    return 1;
  }
  
  return 0;
}

/* This function returns the number of elements in the list.
 */
unsigned int size(const Prio_que prio_q){
  Prio_que *curr;
  int counter = 0;

  /* Set curr to head node if it exists */
  curr = prio_q.next;

  /* count elements */
  while(curr != NULL){
    counter++;
    curr = curr->next;
  }

  return counter;
}

/* This function parses through the list and finds the element with the highest
 * priority. The function returns a dynamically allocated deep copy of the 
 * element named stored in the peek node. 
 */
char *peek(Prio_que prio_q){
  Prio_que *curr;
  int target = 0;
  char *string;

  /* Check base case */
  if (prio_q.next == NULL){
    return NULL;
  }
  
  /* Set curr to head node */
  curr = prio_q.next;

  /* Find the value of the head node */
  while(curr != NULL){
    if (curr->priority > target){
      target = curr->priority;
    }
    curr = curr->next;
  }
  
  curr = prio_q.next;

  /* Parse to head node */
  while(curr != NULL){
    if (curr->priority == target){
      /* Return deep copy */
      string = malloc(strlen(curr->element) + 1);
      strcpy(string, curr->element);
      return string;
    }
    curr = curr->next;
  }
  return NULL;
}

/* This function dequeues the peek node from the linked list and frees it. 
 * The function returns a new dynamically allocated string that is 
 * a deep copy of the node's element string.
 */
char *dequeue(Prio_que *const prio_q){
  Prio_que *curr, *temp;
  int target = 0;
  char *string;
  
  /* Check base cases */
  if (prio_q == NULL){
    return NULL;
  }

  if (prio_q->next == NULL){
    return NULL;
  }
  
  /* get first node */
  curr = prio_q->next;

  /* Parse through linked list and find peek node */
  while(curr != NULL){
    if (curr->priority > target){
      target = curr->priority;
    }
    curr = curr->next;
  }

  /* Reset back to dummy head */
  curr = prio_q;

  /* Parse to target node and destroy it */
  while(curr->next != NULL){
    if (curr->next->priority == target){
      temp = curr->next->next;
      /* Make deep copy */
      string = malloc(strlen(curr->next->element) + 1);
      strcpy(string, curr->next->element);
      /* Free from memory and return */
      free(curr->next->element);
      free(curr->next);
      curr->next = temp;
      return string;
    }
    curr = curr->next;
  }
  
  return NULL;
}

/* This function returns a newly created dynamically allocated
 * array of pointers. The pointers themselves represent strings
 * of all the nodes element names in the linked list. This function
 * relies on two helper functions qsort() and parse(). Exactly what these
 * functions do is described below. 
 */
char **get_all_elements(Prio_que prio_q){
  Prio_que *curr;
  char **elements, *temp;
  int i = 0, j = 0;

  /* Allocate Array */
  elements = malloc((size(prio_q) + 1) * sizeof(char*));

  /* Adjust pointer */
  curr = prio_q.next;

  /* Deep copy each node's element parameter into array */
  while(curr != NULL){
    elements[i] = malloc(strlen(curr->element) + 1);
    strcpy(elements[i], curr->element);
    i++;
    curr = curr->next;
  }

  /* Sort array by descending priority via get_priority() */
  for(i = 0; i < size(prio_q); i++){
    for(j = i + 1; j < size(prio_q); j++){
      if(get_priority(prio_q, elements[i]) < get_priority(prio_q, elements[j])){
	temp = elements[i];
	elements[i] = elements[j];
	elements[j] = temp;
      }
    }
  }

  /* Set last element to NULL */
  elements[i] = NULL;

  return elements;

}

/* This functions recieves a dynamically allocated array of pointers.
 * Each pointer represents a dynamically allocated string. The function
 * should free each individual string and then free the array itself.
 * Typically, the parameter passed is the returned array from the 
 * get_all_elements() function. If the name_list parameter is NULL
 * the function will return nothing. 
 */
void free_name_list(char *name_list[]){
  int i = 0;
  
  /* Base Case */
  if (name_list == NULL){
    return;
  }
  
  /* Iterate through array and free memory */
  while (name_list[i] != NULL){
    free(name_list[i]);
    i++;
  }
  
  /* Free array itself */
  free(name_list);
  
}

/* This function should free all dynamically allocated memory
 * in the priority queue. The use of this function is simple
 * in a sense that all it does is destroy the linked list. 
 * The function takes a const prio_q pointer as an argument. 
 */
void clear(Prio_que *const prio_q){
  Prio_que *curr, *new_head;

  /* Base Case check */
  if (prio_q == NULL){
    return;
  }

  /* Adjust list pointer */
  curr = prio_q;

  /* Destroy linked list */
  while(curr->next != NULL){
    new_head = curr->next->next;
    free(curr->next->element);
    free(curr->next);
    curr->next = new_head;
  }
}

/* This function should traverse the linked list and find 
 * the priority of the associated element. This implementation
 * of a priority queue allows for multiple elements to share 
 * the same name. So if this is the case. 
 */
int get_priority(Prio_que prio_q, char element[]){
  Prio_que *curr;
  int priority = -1;

  /* Check Base Case */
  if (element == NULL){
    return priority;
  }

  /* Adjust prio-q pointer */
  curr = prio_q.next;

  /* Traverse linked list and find corresponding priority */
  while(curr != NULL){
    if (strcmp(curr->element, element) == 0){
      if (curr->priority > priority){
	priority = curr->priority;
      }
    }
    curr = curr->next;
  }

  return priority; 

}

/* This function should traverse the linked list and free any elements whose
 * values fall between low and high priorities (inclusive). The function
 * takes three parameters: A priority queue, a integer low, and a integer
 * high. The function returns the number of elements removed.  
 */
unsigned int remove_elements_between(Prio_que *const prio_q, unsigned int low, 
				     unsigned int high){
  Prio_que *curr, *next_node;
  unsigned int destroyed = 0;

  /* Check Base Case */
  if(prio_q == NULL){
    return destroyed;
  }

  /* Adjust pointer */
  curr = prio_q;
  
  /* Traverse list and free all elements within the inclusive range */
  while(curr->next != NULL){
    if (curr->next->priority >= low && curr->next->priority <= high){
      next_node = curr->next->next;
      free(curr->next->element);
      free(curr->next);
      curr->next = next_node;
      destroyed++;
    }
    curr = curr->next;
  }
     
  /* Return number of destroyed elements */
  return destroyed;
  
}

/* This function should traverse the linked list and change the 
 * priority for the target node. The function should return 1 
 * if a priority was successfully changed and 0 otherwise. 
 * Note, that the cases in which 0 will be returned are as 
 * follows: if element does not exist in the queue, if there's
 * an element with priority equal to new_priority, if there are
 * multiple occurences of new_priority in the list. 
 */
unsigned int change_priority(Prio_que *prio_q, char element[], 
			     unsigned int new_priority){
  Prio_que *curr;
  unsigned int success = 0, occurences = 0;

  /* Check Base Case */
  if(prio_q == NULL || element == NULL){
    return success;
  }
  
  /* Adjust pointer */
  curr = prio_q->next;

  /* This while loop acts a sort of error counter, the while 
   * loop traverse the linked list and checks the edge cases 
   * described above. If this while loop yields one then it's 
   * valid call. However any other value other then one is 
   * considered invalid. 
   */
  while(curr != NULL){
    /* Check if element exists / multiple exist */
    if (strcmp(curr->element, element) == 0){
      occurences++;
    }
    /* Check for previous priorities */
    if (curr->priority == new_priority){
      occurences++;
    }

    curr = curr->next;
  }

  curr = prio_q->next;

  /* change target priority */
  while(occurences == 1 && curr != NULL){
    if (strcmp(curr->element, element) == 0){
      curr->priority = new_priority;
      success++;
    }
    curr = curr->next;
  }
   
  /* return success */
  return success;
  
}
