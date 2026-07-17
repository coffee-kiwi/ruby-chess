require_relative '../all_pieces'

class Rook < Pieces

  attr_reader :team, :piece
  attr_accessor :position, :move_count
  def initialize(team, position)
  @team = team
  @position = position
  @piece = "rook"
  @move_count = 0
  end

  def movement(chessboard)
    all_possible_moves = []
    upwards = up_check(chessboard)
    right = right_check(chessboard)
    downwards = down_check(chessboard)
    left = left_check(chessboard)
    upwards.each { |val| all_possible_moves << val unless val == [] }
    right.each { |val| all_possible_moves << val unless val == [] }
    downwards.each { |val| all_possible_moves << val unless val == [] }
    left.each { |val| all_possible_moves << val unless val == [] }
    if castle_left?(chessboard)
      all_possible_moves << "castleleft"
    end
    if castle_right?(chessboard)
      all_possible_moves << "castleright"
    end

    all_possible_moves
  end

  def capturable(chessboard)
    capture_pieces = []
    capture_pieces << up_enemy_check(chessboard)
    capture_pieces << left_enemy_check(chessboard)
    capture_pieces << down_enemy_check(chessboard)
    capture_pieces << right_enemy_check(chessboard)
    capture_pieces.compact
  end

  def castle_right?(chessboard)
    if @team == "b" && chessboard[0][4] != nil && chessboard[0][4].class == King
      if @move_count == 0 && chessboard[0][4].move_count == 0
        if chessboard[0][5].nil? && chessboard[0][6].nil?
          return true
        end
      end
    elsif @team == "w" && chessboard[7][4] != nil && chessboard[7][4].class == King
      if @move_count == 0 && chessboard[7][4].move_count == 0
        if chessboard[7][5].nil? && chessboard[7][6].nil?
          return true
        end
      end
    end
    return false
  end

  def castle_left?(chessboard)
    if @team == "b" && chessboard[0][4] != nil && chessboard[0][4].class == King
      if @move_count == 0 && chessboard[0][4].move_count == 0
        if chessboard[0][1].nil? && chessboard[0][2].nil? && chessboard[0][3].nil?
          return true
        end
      end
    elsif @team == "w" && chessboard[7][4] != nil && chessboard[7][4].class == King
      if @move_count == 0 && chessboard[7][4].move_count == 0
        if chessboard[7][1].nil? && chessboard[7][2].nil? && chessboard[7][3].nil?
          return true
        end
      end
    end
    return false
  end

end