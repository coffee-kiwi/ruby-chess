require_relative '../all_pieces'

class Rook < Pieces

  attr_reader :team, :piece
  attr_accessor :position, :move_count

  STRAIGHTS = %i[ up down left right].freeze

  def initialize(team, position)
  @team = team
  @position = position
  @piece = "rook"
  @move_count = 0
  end

  def movement(chessboard)
    moves = STRAIGHTS.flat_map { |dir| scan(chessboard, dir) }
    moves << "castleleft" if castle_left?(chessboard)
    moves << "castleright" if castle_right?(chessboard)
    moves
  end

  def capturable(chessboard)
    STRAIGHTS.filter_map { |dir| scan_for_enemy(chessboard, dir) }
  end

  def castle_right?(chessboard)
    if @team == "b" && chessboard[0][4] && chessboard[0][4].class == King
      if @move_count == 0 && chessboard[0][4].move_count == 0
        if chessboard[0][5].nil? && chessboard[0][6].nil?
          return true
        end
      end
    elsif @team == "w" && chessboard[7][4] && chessboard[7][4].class == King
      if @move_count == 0 && chessboard[7][4].move_count == 0
        if chessboard[7][5].nil? && chessboard[7][6].nil?
          return true
        end
      end
    end
    return false
  end

  def castle_left?(chessboard)
    if @team == "b" && chessboard[0][4] && chessboard[0][4].class == King
      if @move_count == 0 && chessboard[0][4].move_count == 0
        if chessboard[0][1].nil? && chessboard[0][2].nil? && chessboard[0][3].nil?
          return true
        end
      end
    elsif @team == "w" && chessboard[7][4] && chessboard[7][4].class == King
      if @move_count == 0 && chessboard[7][4].move_count == 0
        if chessboard[7][1].nil? && chessboard[7][2].nil? && chessboard[7][3].nil?
          return true
        end
      end
    end
    return false
  end

end