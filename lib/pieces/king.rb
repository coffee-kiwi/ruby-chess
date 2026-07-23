require 'pry-byebug'
require_relative '../all_pieces'

class King
  
  attr_reader :team, :piece
  attr_accessor :position, :move_count
  def initialize(team, position)
    @team = team
    @position = position
    @piece = "king"
    @move_count = 0
  end

  def movement(chessboard)
    new_positions = []
    row = @position[0]
    col = @position[1]
    movement_array = [[-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1]]
    movement_array.each do |x, y|
      new_row = row + x
      new_col = col + y
      if new_row.between?(0,7) && new_col.between?(0,7)
        new_positions << [new_row, new_col] if chessboard[new_row][new_col].nil?
      end
    end
    
    if castle_left?(chessboard)
      new_positions << "castleleft"
    end
    if castle_right?(chessboard)
      new_positions << "castleright"
    end
    new_positions
  end

  def capturable(chessboard)
    enemy_pieces = []
    row = @position[0]
    col = @position[1]
    movement_array = movement_array = [[-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1]]
    movement_array.each do |x, y|
      new_row = row + x
      new_col = col + y
      if new_row.between?(0,7) && new_col.between?(0,7)
        if chessboard[new_row][new_col]
          enemy_pieces << [new_row, new_col] if chessboard[new_row][new_col].team != @team
        end
      end
    end
    enemy_pieces
  end

  def castle_right?(chessboard)
    if @team == "b" && chessboard[0][7].class == Rook
      if @move_count == 0 && chessboard[0][7].move_count == 0
        if chessboard[0][5].nil? && chessboard[0][6].nil?
          return true
        end
      end
    elsif @team == "w" && chessboard[7][7].class == Rook
      if @move_count == 0 && chessboard[7][7].move_count == 0
        if chessboard[7][5].nil? && chessboard[7][6].nil?
          return true
        end
      end
    end
    return false
  end

  def castle_left?(chessboard)
    if @team == "b" && chessboard[0][0].class == Rook
      if @move_count == 0 && chessboard[0][0].move_count == 0
        if chessboard[0][1].nil? && chessboard[0][2].nil? && chessboard[0][3].nil?
          return true
        end
      end
    elsif @team == "w" && chessboard[7][0].class == Rook
      if @move_count == 0 && chessboard[7][0].move_count == 0
        if chessboard[7][1].nil? && chessboard[7][2].nil? && chessboard[7][3].nil?
          return true
        end
      end
    end
    return false
  end
end