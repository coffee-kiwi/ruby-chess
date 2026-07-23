require 'pry-byebug'
require_relative '../board'

class Knight
  
  attr_reader :team, :piece
  attr_accessor :position
  def initialize(team, position)
    @team = team
    @position = position
    @piece = "knight"
  end

  def movement(chessboard)
    new_positions = []
    row = @position[0]
    col = @position[1]
    movement_array = [[1,2], [2,1], [2,-1], [1,-2], [-1,-2], [-2,-1], [-2,1], [-1,2]]
    movement_array.each do |x, y|
      new_row = row + x
      new_col = col + y
      if new_row.between?(0,7) && new_col.between?(0,7)
        new_positions << [new_row, new_col] if chessboard[new_row][new_col].nil?
      end
    end
    new_positions
  end

  def capturable(chessboard)
    enemy_pieces = []
    row = @position[0]
    col = @position[1]
    movement_array = [[1,2], [2,1], [2,-1], [1,-2], [-1,-2], [-2,-1], [-2,1], [-1,2]]
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
end