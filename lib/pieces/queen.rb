require 'pry-byebug'
require_relative '../all_pieces'

class Queen < Pieces
  
  attr_reader :team, :piece
  attr_accessor :position

  def initialize(team, position)
    @team = team
    @position = position
    @piece = "queen"
  end

  def movement(chessboard)
    DIRECTIONS.keys.flat_map { |dir| scan(chessboard, dir) }
  end

  def capturable(chessboard)
    DIRECTIONS.keys.filter_map { |dir| scan_for_enemy(chessboard, dir) }
  end
end