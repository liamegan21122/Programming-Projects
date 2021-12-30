class GameBoard
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column
        @gameboard = Array.new(max_column + 1){Array.new(max_row + 1){Array.new(2)}}
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
      start_position_row = ship.start_position.row
      start_position_col = ship.start_position.column
      orientation = ship.orientation
      size = ship.size

      #Check if coordinates are valid
      if start_position_row < 1 || start_position_row > @max_row ||start_position_col < 1 || start_position_col > @max_column
        return false
      end

      #since position is valid check if orientation is valid
      if orientation == "Up"
        if (start_position_row - size) < 0
          return false
        end
      end

      if orientation == "Down"
        if (start_position_row + size) > (@max_row + 1)
          return false
        end
      end

      if orientation == "Left"
        if (start_position_col - size) < 0
          return false
        end
      end

      if orientation == "Right"
        if (start_position_col + size) > (@max_column + 1)
          return false
        end
      end 

      #check for overlap
      if orientation == "Up"
        i = 0
        while i < size
          if @gameboard[start_position_row - i][start_position_col][0] == "B"
            return false
          end 
          i += 1
        end
      end

      if orientation == "Down"
        i = 0
        while i < size
          if @gameboard[start_position_row + i][start_position_col][0] == "B"
            return false
          end
          i += 1
        end
      end

      if orientation == "Left"
        i = 0
        while i < size
          if @gameboard[start_position_row][start_position_col - 1][0] == "B"
            return false
          end
          i += 1
        end
      end

      if orientation == "Right"
        i = 0
        while i < size
          if @gameboard[start_position_row][start_position_col + 1][0] == "B"
            return false
          end
          i += 1
        end
      end

      #insert ship

      if orientation == "Up"
        i = 0
        while i < size
          @gameboard[start_position_row - i][start_position_col][0] = "B"
          i += 1
        end
        return true
      end

      if orientation == "Down"
        i = 0
        while i < size
          @gameboard[start_position_row + i][start_position_col][0] = "B"
          i += 1
        end
        return true
      end

      if orientation == "Left"
        i = 0
        while i < size
          @gameboard[start_position_row][start_position_col - i][0] = "B"
          i += 1
        end
        return true
      end

      if orientation == "Right"
        i = 0
        while i < size
          @gameboard[start_position_row][start_position_col + i][0] = "B"
          i += 1
        end
        return true
      end

      return false
      
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
      start_position_row = position.row
      start_position_col = position.column
      
      # check position
      if start_position_row < 1 || start_position_row > @max_row || start_position_col < 1 || start_position_col > @max_column
        return nil
      end 
      # update your grid
      @gameboard[start_position_row][start_position_col][1] = "A"

      if @gameboard[start_position_row][start_position_col][0] == "B"
        return true
      end
      # return whether the attack was successful or not
        return false
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
      successful_attacks = 0
      for row in 1..@max_row
        for col in 1..@max_column
          if @gameboard[row][col][0] == "B" && @gameboard[row][col][1] == "A"
            successful_attacks += 1
          end
        end
      end

      return successful_attacks
      
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
      for row in 1..@max_row
        for col in 1..@max_column
          if @gameboard[row][col][0] == "B" && @gameboard[row][col][1] != "A"
            return false
          end
        end
      end
      return true
    end
end
