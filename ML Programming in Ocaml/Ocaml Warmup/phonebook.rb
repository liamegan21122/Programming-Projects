class PhoneBook
  def initialize
    @names = []
    @numbers = []
    @listed = []
    end

  def add(name, number, is_listed)
    #check if number is valid 
      if number.length != 12
        return false
      end

      #check for duplicate
      i = 0
      while i < @names.length
        if @names[i] == name
          if @numbers[i] == number
            return false
          end
        end
        i += 1
      end

      #check if number is already listed
      i = 0
      while i < @listed.length
        if @listed[i] == number
          return false
        end
        i += 1
      end

      #add number
      @names.push(name)
      @numbers.push(number)

      if is_listed == true
        @listed.push(number)
      end

      return true
      
    end

    def lookup(name)
      #check for name in phone book
      i = 0
      target = -1
      while i < @names.length
        if @names[i] == name
          target = i
        end
        i += 1
      end

      if target == -1
        return nil
      end

      i = 0
      while i < @listed.length
        if @numbers[target] == @listed[i]
          return @listed[i]
        end
        i += 1
      end

      return nil
    end

    def lookupByNum(number)
      #check if number exists
      i = 0
      target = -1
      while i < @numbers.length
        if @numbers[i] == number
          target = i
        end
        i += 1
      end

      if target == -1
        return nil
      end

      i = 0
      
      while i < @listed.length
        if @listed[i] == @numbers[target]
          return @names[target]
        end
        i += 1
      end

      return nil
      
    end

    def namesByAc(areacode)
      array = []
      i = 0
      while i < @numbers.length
        if @numbers[i].include? areacode
          array.push(@names[i])
        end
        i += 1
      end
      return array
    end
end
