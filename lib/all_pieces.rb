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

  def left_check(chessboard)
    possible_moves = []
    row = @position[0]
    col = @position[1] - 1
    while col.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    col -= 1
    end
    possible_moves
  end

  def left_enemy_check(chessboard)
    row = @position[0]
    col = @position[1] - 1
    while col.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == @team
          return nil
        elsif chessboard[row][col].team != @team
          return [row, col]
        end
      end
      col -= 1
    end
  end

  def right_check(chessboard)
    possible_moves = []
    row = @position[0]
    col = @position[1] + 1
    while col.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    col += 1
    end
    possible_moves
  end

  def right_enemy_check(chessboard)
    row = @position[0]
    col = @position[1] + 1
    while col.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == @team
          return nil
        elsif chessboard[row][col].team != @team
          return [row, col]
        end
      end
      col += 1
    end
  end

  def down_check(chessboard)
    possible_moves = []
    row = @position[0] + 1
    col = @position[1]
    while row.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    row += 1
    end
    possible_moves
  end

  def down_enemy_check(chessboard)
    row = @position[0] + 1
    col = @position[1]
    while row.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == @team
          return nil
        elsif chessboard[row][col].team != @team
          return [row, col]
        end
      end
      row += 1
    end
  end

  def up_check(chessboard)
    possible_moves = []
    row = @position[0] - 1
    col = @position[1]
    while row.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    row -= 1
    end
    possible_moves
  end

  def up_enemy_check(chessboard)
    row = @position[0] - 1
    col = @position[1]
    while row.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == @team
          return nil
        elsif chessboard[row][col].team != @team
          return [row, col]
        end
      end
      row -= 1
    end
  end

  def up_left_check(chessboard)
    possible_moves = []
    row = @position[0] - 1
    col = @position[1] - 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    row -= 1
    col -= 1
    end
    possible_moves
  end

  def enemy_up_left_check(chessboard)
    possible_moves = []
    row = @position[0] - 1
    col = @position[1] - 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == team
          return nil
        elsif chessboard[row][col].team != team
          return [row, col]
        end
      end
      row -= 1
      col -= 1
    end
  end

    # Method for upper right check
  def up_right_check(chessboard)
    possible_moves = []
    row = @position[0] - 1
    col = @position[1] + 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    row -= 1
    col += 1
    end
    possible_moves
  end

  def enemy_up_right_check(chessboard)
    possible_moves = []
    row = @position[0] - 1
    col = @position[1] + 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == team
          return nil
        elsif chessboard[row][col].team != team
          return [row, col]
        end
      end
      row -= 1
      col += 1
    end
  end

  def low_right_check(chessboard)
    possible_moves = []
    row = @position[0] + 1
    col = @position[1] + 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col].nil?
        possible_moves << [row, col]
      else
        break
      end
    row += 1
    col += 1
    end
    possible_moves
  end

  def enemy_low_right_check(chessboard)
    possible_moves = []
    row = @position[0] + 1
    col = @position[1] + 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == team
          return nil
        elsif chessboard[row][col].team != team
          return [row, col]
        end
      end
      row += 1
      col += 1
    end
  end

  def low_left_check(chessboard)
    possible_moves = []
    row = @position[0] + 1
    col = @position[1] - 1
    while row.between?(0,7) && col.between?(0,7)
        if chessboard[row][col].nil?
          possible_moves << [row, col]
        else
          break
        end
      row += 1
      col -= 1
    end
    possible_moves
  end

  def enemy_low_left_check(chessboard)
    possible_moves = []
    row = @position[0] + 1
    col = @position[1] - 1
    while row.between?(0,7) && col.between?(0,7)
      if chessboard[row][col] != nil
        if chessboard[row][col].team == team
          return nil
        elsif chessboard[row][col].team != team
          return [row, col]
        end
      end
      row += 1
      col -= 1
    end
  end
end
