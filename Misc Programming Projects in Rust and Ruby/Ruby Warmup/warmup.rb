def fib(n)

  array = []

  if n == 0
    return array
  end

  if n == 1
    array[0] = 0
    return array
  end

  a = 0
  b = 1

  array[0] = 0
  array[1] = 1

  while n > 2
    temp = a + b
    array.push(temp)
    a = b
    b = temp
    n = n - 1
  end

  return array
    
end

def isPalindrome(n)
  palindrome = n.to_s

  if palindrome == palindrome.reverse
    return true
  end

  return false

end

def nthmax(n, a)
  
  if n >= a.length()
    return nil
  end

  sorted = a.sort{|x,y| y<=>x}

  return sorted[n]
  
end

def freq(s)
  if (s == "")
    return ""
  end

  frequency = s.count(s[0])

  target = s[0]
  
  i = 0

  while i < s.length - 1
    temp = s.count(s[i])
    
    if temp > frequency
      frequency = temp
      target = s[i]
    end
      
    i = i + 1
  end

  return target
     
end

def zipHash(arr1, arr2)
  if arr1.length != arr2.length
    return nil
  end

  return Hash[arr1.zip(arr2)]
  
end

def hashToArray(hash)
  
  return hash.to_a
    
end
