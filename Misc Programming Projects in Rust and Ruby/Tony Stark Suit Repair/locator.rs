use std::cmp::Ordering;
use std::collections::HashMap;

pub trait PriorityQueue<T: PartialOrd> {
    fn enqueue(&mut self, ele: T) -> ();
    fn dequeue(&mut self) -> Option<T>;
    fn peek(&self) -> Option<&T>;
}

struct Node<T> {
    priority: i32,
    data: T,
}

impl<T> PartialOrd for Node<T> {
    fn partial_cmp(&self, other: &Node<T>) -> Option<Ordering> {
        self.priority.partial_cmp(&other.priority)
    }
}

impl<T> PartialEq for Node<T> {
    fn eq(&self, other: &Node<T>) -> bool {
        self.priority == other.priority
    }
}

fn min_heapify<T: PartialOrd>(index: usize, v: &mut Vec<T>) -> () { 
	if v.get(2*index + 1) != None && v[2*index + 1] < v[index] && 
		(v.get(2*index + 2) == None || v[2*index + 1] < v[2*index + 2] ) {
 
		v.swap(2*index + 1, index); 
		min_heapify(2*index + 1, v)
	}

	else if v.get(2*index + 2) != None && v.get(2*index + 2) < v.get(index) && 
		(v.get(2*index + 2) < v.get(2*index + 1) || v.get(2*index + 1) == None){

		v.swap(2*index + 2, index); 
		min_heapify(2*index + 2, v)
	}
}

impl<T: PartialOrd> PriorityQueue<T> for Vec<T> {
    fn enqueue(&mut self, ele: T) -> () {
        self.push(ele);						
    	if self.len() > 1 {	
		let index = self.len() - 1;
		if self.get((index-1) / 2) != None && self[index] < self[(index-1) / 2] {
			self.swap(index, (index-1) / 2);
			min_heapify((index-1) / 2, self)
		}				
    	}
    }
	
  fn dequeue(&mut self) -> Option<T> {
        	if self.len() > 0 {
			let length = self.len();
        		self.swap(0, length - 1);
        		let first = self.pop();
        		min_heapify(0, self);
        		return Some(first.unwrap())
        	}
        	else {
        		return None
        	}
    }

    fn peek(&self) -> Option<&T> {
        if self.len() == 0 {
        	return None
        }
        else {
        	Some(&self[0])
        }
    }
}

pub fn distance(p1: (i32,i32), p2: (i32,i32)) -> i32 {
    let (x1, y1) = p1;
    let (x2, y2) = p2;
    (x1 - x2).abs() + (y1 - y2).abs()
}

pub fn target_locator<'a>(allies: &'a HashMap<&String, (i32,i32)>, enemies: &'a HashMap<&String, (i32,i32)>) -> (&'a str,i32,i32) {

	let mut matched = Vec::new();
	let mut heap = Vec::new();

	for (allykey, allyval) in allies.iter() {
		for (enemkey, enemval) in enemies.iter() {
			let dist = distance(*allyval, *enemval);
			let new_node = Node {
				priority: dist,
				data: (allykey, enemkey),
			};

			heap.enqueue(new_node);
		}
	}
 
	while heap.len() > 0 {
		let new_node = heap.dequeue().unwrap();
		let (ally, enemy) = new_node.data;
		if **ally == "Stark".to_string(){
			let (x,y) = enemies.get(enemy).unwrap();
			return (&enemy, *x, *y)		
		}
		else if matched.contains(&ally) == false {
			matched.push(ally);
		}
	}

	return ("Something went wrong", -1000, -1000)
}



