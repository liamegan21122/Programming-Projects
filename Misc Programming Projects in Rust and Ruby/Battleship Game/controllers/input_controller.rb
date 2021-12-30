require_relative '../models/game_board'
require_relative '../models/ship'
require_relative '../models/position'

# return a populated GameBoard or nil
# Return nil on any error (validation error or file opening error)
# If 5 valid ships added, return GameBoard; return nil otherwise
def read_ships_file(path)
  game_board = GameBoard.new 10, 10

  if read_file_lines(path) == false
    return nil
  end

  file_data = File.read(path).split

  i = 0
  array = []
  limit = 0

  while file_data[i] != nil
    if limit != 3
      if limit < 2
        array[limit] = file_data[i][0...-1]
      end

      if limit == 2
        array[limit] = file_data[i]
      end
      
      limit += 1
    end

    if limit == 3
      new_position = Position.new array[0][1].to_i, array[0][3].to_i
      new_ship = Ship.new new_position, array[1], array[2].to_i
      if game_board.add_ship(new_ship) == false
        return nil
      end

      game_board.add_ship(new_ship)
      
      limit = 0
    end

    i += 1
    
  end


  return game_board
   
end


# return Array of Position or nil
# Returns nil on file open error
def read_attacks_file(path)
  if read_file_lines(path) == false
    return nil
  end

  file_data = File.read(path).split

  i = 0
  instruction = 0
  temp_array = []
  positions = []
  while file_data[i] != nil

    if file_data[i].length == 5 && file_data[i][0] == "(" && file_data[i][2] == "," && file_data[i][4] == ")"
      new_position = Position.new file_data[i][1].to_i, file_data[i][3].to_i
      positions.push(new_position)
    end
    i += 1
  end

  return positions
  
end


# ===========================================
# =====DON'T modify the following code=======
# ===========================================
# Use this code for reading files
# Pass a code block that would accept a file line
# and does something with it
# Returns True on successfully opening the file
# Returns False if file doesn't exist
def read_file_lines(path)
    return false unless File.exist? path
    if block_given?
        File.open(path).each do |line|
            yield line
        end
    end

    true
end
