class BlackPawn < Pieces

  attr_reader :team, :piece
  attr_accessor :position
  def initialize(team, position)
    @position = position
    @team = team
    @piece = "black_pawn"
  end

  def movement(chessboard)
    possible_moves = []
    row = @position[0]
    col = @position[1]
    if row == 1
      possible_moves << [row + 1, col] if chessboard[row + 1][col].nil?
      possible_moves << [row + 2, col] if chessboard[row + 2][col].nil? && chessboard[row + 1][col].nil?
    elsif row > 1
      possible_moves << [row + 1, col] if chessboard[row + 1][col].nil?
    end
    possible_moves
  end

  def capturable(chessboard, en_passant)
    capturable_pieces = []
    row = @position[0]
    col = @position[1]
    if col.between?(1,6) && row < 7
      left = chessboard[row + 1][col - 1]
      right = chessboard[row + 1][col + 1]
      if left && left.team != @team || [row + 1, col - 1] == en_passant
        capturable_pieces << [row + 1, col - 1]
      end
      if right && right.team != @team || [row + 1, col + 1] == en_passant
        capturable_pieces << [row + 1, col + 1]
      end
    elsif col == 0
      right = chessboard[row + 1][col + 1]
      capturable_pieces << [row + 1, col + 1] if right && right.team != @team
    elsif col == 7
      left = chessboard[row + 1][col - 1]
      capturable_pieces << [row + 1, col + 1] if left && left.team != @team
    end
    capturable_pieces
  end

  def upgrade(chessboard)
    if @position[0] == 7
      correct_input = false
      until correct_input == true
        puts "Pawn may be upgraded, what class would you like?"
        puts "'rook' / 'knight' / 'bishop' / 'queen' ?"
        upgraded_piece = gets.chomp  

        case upgraded_piece
        when 'rook'
        correct_input = true
        chessboard[@position[0]][@position[1]]
        chessboard[@position[0]][@position[1]] = Rook.new("b", @position)
        when 'knight'
        correct_input = true
        chessboard[@position[0]][@position[1]]
        chessboard[@position[0]][@position[1]] = Knight.new("b", @position)
        when 'bishop'
        correct_input = true
        chessboard[@position[0]][@position[1]]
        chessboard[@position[0]][@position[1]] = Bishop.new("b", @position)
        when 'queen'
        correct_input = true
        chessboard[@position[0]][@position[1]]
        chessboard[@position[0]][@position[1]] = Queen.new("b", @position)
        end
      end
    end
  end
end