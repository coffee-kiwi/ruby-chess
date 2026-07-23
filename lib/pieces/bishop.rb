require_relative '../board'
require_relative '../all_pieces'

class Bishop < Pieces

  attr_reader :team, :piece

  DIAGONALS = %i[up_left up_right low_left low_right].freeze

  attr_accessor :position
    def initialize(team, position)
      @position = position
      @team = team
      @piece = "bishop"
    end

    def movement(chessboard)
      DIAGONALS.flat_map { |dir| scan(chessboard, dir) }
    end

    def capturable(chessboard)
      DIAGONALS.filter_map { |dir| scan_for_enemy(chessboard, dir) }
    end
end