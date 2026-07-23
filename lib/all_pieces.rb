class Pieces

  DIRECTIONS = {
    up: [-1, 0],
    down: [1, 0],
    left: [0, -1],
    right: [0, 1],
    up_left: [-1, -1],
    up_right: [-1, 1],
    low_left: [1, -1],
    low_right: [1, 1]
  }.freeze
  
  BOARD_RANGE = (0..7).freeze

  def scan(chessboard, direction)
    row_movement, col_movement = DIRECTIONS.fetch(direction)
    row = @position[0] + row_movement
    col = @position[1] + col_movement
    possible_moves = []

    while BOARD_RANGE.cover?(row) && BOARD_RANGE.cover?(col)
      break unless chessboard[row][col].nil?
      possible_moves << [row, col]
      row += row_movement
      col += col_movement
    end
    possible_moves
  end

  def scan_for_enemy(chessboard, direction)
    row_movement, col_movement = DIRECTIONS.fetch(direction)
    row = @position[0] + row_movement
    col = @position[1] + col_movement
    while BOARD_RANGE.cover?(row) && BOARD_RANGE.cover?(col)
      square = chessboard[row][col]
      unless square.nil?
        return square.team == @team ? nil : [row, col]
      end
      row += row_movement
      col += col_movement
    end
    nil
  end

  def up_check(chessboard); scan(chessboard, :up); end
  def down_check(chessboard); scan(chessboard, :down); end
  def left_check(chessboard); scan(chessboard, :left); end  
  def right_check(chessboard); scan(chessboard, :right); end
  def up_left_check(chessboard); scan(chessboard, :up_left); end
  def up_right_check(chessboard); scan(chessboard, :up_right); end
  def low_left_check(chessboard); scan(chessboard, :low_left); end
  def low_right_check(chessboard); scan(chessboard, :low_right); end

  def up_enemy_check(chessboard); scan_for_enemy(chessboard, :up); end
  def down_enemy_check(chessboard); scan_for_enemy(chessboard, :down); end
  def left_enemy_check(chessboard); scan_for_enemy(chessboard, :left); end
  def right_enemy_check(chessboard); scan_for_enemy(chessboard, :right); end
  def up_left_enemy_check(chessboard); scan_for_enemy(chessboard, :up_left); end
  def up_right_enemy_check(chessboard); scan_for_enemy(chessboard, :up_right); end
  def low_left_enemy_check(chessboard); scan_for_enemy(chessboard, :low_left); end
  def low_right_enemy_check(chessboard); scan_for_enemy(chessboard, :low_right); end
  
end
