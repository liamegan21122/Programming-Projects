/**
    Returns the sum 1 + 2 + ... + n
    If n is less than 0, return -1
**/
pub fn gauss(n: i32) -> i32 {
    if n < 0 {
        return -1
    } else {
        (n*n+n)/2
    }
}

/**
    Returns the number of elements in the list that 
    are in the range [s,e]
**/
pub fn in_range(ls: &[i32], s: i32, e: i32) -> i32 {
    let mut counter: i32 = 0;
    
    for l in ls.iter() {
        if l >= &s && l <= &e {
           counter += 1;
        }
    }
    
   counter
}

/**
    Returns true if target is a subset of set, false otherwise

    Ex: [1,3,2] is a subset of [1,2,3,4,5]
**/
pub fn subset<T: PartialEq>(set: &[T], target: &[T]) -> bool {
    let mut x = false;
    let mut counter = 1;

    if target == [] {
        return true
    }
    
    for t in target.iter() {
        for s in set.iter() {
            if t == s {
                x = true;
            }
        }

        if counter == target.len() {
            return x
        } else if x == false {
           return false
        } else {
            x = false;
        } 
        counter += 1;
    }
    
    true
}

/**
    Returns the mean of elements in ls. If the list is empty, return None
    It might be helpful to use the fold method of the Iterator trait
**/
pub fn mean(ls: &[f64]) -> Option<f64> {
    if ls == [] {
        return None
    }
    else{
        let mut sum: f64 = 0.0;
        
        for i in ls.iter() {
            sum = sum + i;
        }
        return Some(sum / (ls.len() as f64))
    }
}

/**
    Converts a binary number to decimal, where each bit is stored in order in the array
    
    Ex: to_decimal of [1,0,1,0] returns 10
**/
pub fn to_decimal(ls: &[i32]) -> i32 {
    if ls == [] {
        return 0
    } else {
        let mut sum: i32 = 0;
        for (i, e) in ls.iter().rev().enumerate() {
            if e == &1 {
                sum = sum + (2 as i32).pow(i as u32);
            }
        }
        
        sum
    }
}

/**
    Decomposes an integer into its prime factors and returns them in a vector
    You can assume factorize will never be passed anything less than 2

    Ex: factorize of 36 should return [2,2,3,3] since 36 = 2 * 2 * 3 * 3
**/
pub fn factorize(n: u32) -> Vec<u32> {
    let mut vec = Vec::new();
    let mut num: u32 = n;
    let mut d: u32 = 2;
    
    while d*d <= n {
        while (num % d) == 0 {
            vec.push(d);
            num = num / d;
        }
        d = d + 1;
    }
    if num > 1{
        vec.push(n);
    }
    
    return vec
}

/** 
    Takes all of the elements of the given slice and creates a new vector.
    The new vector takes all the elements of the original and rotates them, 
    so the first becomes the last, the second becomes first, and so on.
    
    EX: rotate [1,2,3,4] returns [2,3,4,1]
**/
pub fn rotate(lst: &[i32]) -> Vec<i32> {
    let mut v = Vec::new();
    if lst == [] {
        return v;
    }
    for i in 0..lst.len()-1{
        v.push(lst[i+1]);
    }
    v.push(lst[0]);
    return v;
}

/**
    Returns true if target is a subtring of s, false otherwise
    You should not use the contains function of the string library in your implementation
    
    Ex: "ace" is a substring of "rustacean"
**/
pub fn substr(s: &String, target: &str) -> bool {
    
    if s == ""{
        return true
    }
    
    for i in 0..s.len() - 1{
        for j in i..s.len() + 1{
          if &s[i..j] == target {
            return true;
              
          }  
        }
    }
    return false
}

/**
    Takes a string and returns the first longest substring of consecutive equal characters

    EX: longest_sequence of "ababbba" is Some("bbb")
    EX: longest_sequence of "aaabbb" is Some("aaa")
    EX: longest_sequence of "xyz" is Some("x")
    EX: longest_sequence of "" is None
**/
pub fn longest_sequence(s: &str) -> Option<&str> {
    let mut counter: i32 = 0;
    let mut start_index = 0;
    let mut end_index = 1;
    let sub;
    
    if s == ""{
        return None
    }
    
    for i in 0..s.len() - 1{
        let mut temp_count: i32 = 0;
        let temp_start_index: usize = i;
        let mut temp_end_index: usize = i;
        for j in i..s.len(){
            if s.chars().nth(j).unwrap() == s.chars().nth(i).unwrap() {
                temp_count = temp_count + 1;
                temp_end_index = j + 1;
            }
            else{
                break
            }
        }
        
        if temp_count > counter{
            counter = temp_count;
            end_index = temp_end_index;
            start_index = temp_start_index;
        }
    }
    
    sub = &s[start_index..end_index];
    
    return Some (sub)
        
}
