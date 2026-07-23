# module Chess
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/rook'
require_relative 'pieces/white_pawn'
require_relative 'pieces/black_pawn'  
require_relative 'chess_methods'

class Board

  include ChessMethods
  attr_reader :chessboard, :player, :en_passant_w, :en_passant_b
  attr_accessor :remaining_white, :remaining_black

  def initialize
    @chessboard = Array.new(9) { Array.new(9) }
    @remaining_white = []
    @remaining_black = []
    @en_passant_b = nil
    @en_passant_w = nil
    @player = "w"
  end

  def change_player
    @player == "b" ? @player = "w" : @player = "b"
  end

  def set_up_chessboard
    @chessboard[0][0] = Rook.new("b", [0,0])
    @chessboard[0][7] = Rook.new("b", [0,7])
    @chessboard[7][0] = Rook.new("w", [7,0])
    @chessboard[7][7] = Rook.new("w", [7,7])
    @chessboard[0][1] = Knight.new("b", [0,1])
    @chessboard[0][6] = Knight.new("b", [0,6])
    @chessboard[7][1] = Knight.new("w", [7,1])
    @chessboard[7][6] = Knight.new("w", [7,6])
    @chessboard[0][2] = Bishop.new("b", [0,2])
    @chessboard[0][5] = Bishop.new("b", [0,5])
    @chessboard[7][2] = Bishop.new("w", [7,2])
    @chessboard[7][5] = Bishop.new("w", [7,5])
    @chessboard[0][3] = Queen.new("b", [0,3])
    @chessboard[7][3] = Queen.new("w", [7,3])
    @chessboard[0][4] = King.new("b", [0,4])
    @chessboard[7][4] = King.new("w", [7,4])
    count = 0
    while count < 9 do 
      @chessboard[1][count] = BlackPawn.new("b", [1, count])
      @chessboard[6][count] = WhitePawn.new("w", [6, count])
      count += 1
    end
    count = 0
    row = 8
    letter = 97
    while count < 9 do 
      @chessboard[count][8] = "| #{row - count} |"
      @chessboard[8][count] = "| #{(letter+count).chr} |"
      count += 1
    end
    update_remaining_pieces
  end

  def update_remaining_pieces
    @remaining_black = []
    @remaining_white = []
    @chessboard.each do |row|
      row.each do |val|
        if val.is_a?(String) == false
          if val != nil && val.team == "w"
          @remaining_white << val
          elsif val != nil && val.team == "b"
          @remaining_black << val
          end 
        end
      end
    end 
  end
  
  def display_board
    display = @chessboard.map(&:clone)
    display = display.map do |row|
      row.map do |val|
        if val.nil?
          val = "|   |"
        else
          if val.is_a?(String)
            val = val
          elsif val.team == "b"
            case val.piece
            when "black_pawn" then val = "| \u265F |"
            when "rook" then val = "| \u265C |"
            when "knight" then val = "| \u265E |"
            when "bishop" then val = "| \u265D |"
            when "queen" then val = "| \u265B |"
            when "king" then val = "| \u265A |"
            end
          elsif val.team == "w"
            case val.piece
            when "white_pawn" then val = "| \u2659 |"
            when "rook" then val = "| \u2656 |"
            when "knight" then val = "| \u2658 |"
            when "bishop" then val = "| \u2657 |"
            when "queen" then val = "| \u2655 |"
            when "king" then val = "| \u2654 |"
            end
          end
        end
      end
    end
    display.each do |row|
      print "#{row}\n"
    end
  end

  def choose_move
    players_piece = false
    if @player == "w"
      puts "It is now white's turn to move"
    else
      puts "It is now black's turn to move"
    end
    until players_piece == true
      puts "Select one of your pieces to move"
      chosen_piece_position = next_move
      if chosen_piece_position == "save"
        return "save"
      end
      chosen_piece = @chessboard[chosen_piece_position[0]][chosen_piece_position[1]]
      if chosen_piece != nil && chosen_piece.team == @player
        players_piece = true
      end
    end
    chosen_piece
  end

  def calculate_moves(chosen_piece)
    moves = chosen_piece.movement(@chessboard)
    capture = capture_by_type(chosen_piece, @chessboard)  
    until moves != [] || capture != []
      puts "Error, cannot move selected piece. Choose another piece"
      chosen_piece = choose_move
      moves = chosen_piece.movement(@chessboard)
      capture = capture_by_type(chosen_piece, @chessboard)
    end
    readable_moves = convert_to_readable(moves)
    readable_capture = convert_to_readable(capture)
    puts "Possible moves are: #{readable_moves}".colorize(:green)
    puts "Pieces you can capture : #{readable_capture}".colorize(:yellow)
    puts "Choose your next move"
    player_next = next_move

    until moves.include?(player_next) || capture.include?(player_next)
      puts "Sorry, this move cannot be made"
      player_next = next_move
    end
    player_next
  end

  def capture_by_type(piece, board)
    case piece
    when BlackPawn then capture = piece.capturable(board, @en_passant_w)
    when WhitePawn then capture = piece.capturable(board, @en_passant_b)
    else capture = piece.capturable(board)
    end  
    capture
  end
  # Should not allow castling unless both pieces are on the same team..
  def players_move
    chosen_piece = choose_move
    if chosen_piece == "save"
      return "save"
    end
    player_next = calculate_moves(chosen_piece)
    original_position = chosen_piece.position
    moves = chosen_piece.movement(@chessboard)
    capture = capture_by_type(chosen_piece, @chessboard)
    moves = legal_move?(moves, chosen_piece)
    capture = legal_move?(capture, chosen_piece)
    if player_next == "castleleft"
      castling("castleleft", chosen_piece)
    elsif player_next == "castleright"
      castling("castleright", chosen_piece)
    else
      execute_move(player_next, chosen_piece, @chessboard, capture)
      if chosen_piece.class == King || chosen_piece.class == Rook
        chosen_piece.move_count += 1
      end
    end
    
    if chosen_piece.class == BlackPawn || chosen_piece.class == WhitePawn
      chosen_piece.upgrade(@chessboard)
    end
    update_remaining_pieces
  end

  def legal_move?(moves, piece)
    legal_moves = []
    original_position = piece.position
    moves.each do |move|
      copy_board = @chessboard.map(&:clone)
      copy_remaining_black = @remaining_black.clone
      copy_remaining_white = @remaining_white.clone
      # Evaluate if castling is possible or not..
      if move == "castleleft" || move == "castleright"
        
        if castling_test(move, piece, copy_board) == false
          illegal_move = true
        else
          illegal_move = check(copy_board)
        end
      else
        capture = capture_by_type(piece, copy_board)
        execute_move(move, piece, copy_board, capture)
        illegal_move = check(copy_board)
      end
      piece.position = original_position
      if illegal_move
        next
      else
        legal_moves << move
      end
    end
    legal_moves
  end

  def castling_test(direction, piece, board)
    if direction == "castleleft" && piece.team == "b" && board[0][0].team == "b"
      rook = board[0][0]
      king = board[0][4]
      board[0][0] = king
      board[0][4] = rook
    elsif direction == "castleright" && piece.team == "b"  && board[0][7].team == "b"
      rook = board[0][7]
      king = board[0][4]
      board[0][7] = king
      board[0][4] = rook
    elsif direction == "castleleft" && piece.team == "w"  && board[7][0].team == "w"
      rook = board[7][0]
      king = board[7][4]
      board[7][0] = king
      board[7][4] = rook
    elsif direction == "castleright" && piece.team == "w" && board[7][7].team == "w"
      rook = board[7][7]
      king = board[7][4]
      board[7][7] = king
      board[7][4] = rook
    else
      
      false
    end
  end

  def castling(direction, piece)
    if direction == "castleleft" && piece.team == "b"
      rook = @chessboard[0][0]
      king = @chessboard[0][4]
      @chessboard[0][0] = king
      king.position = [0,0]
      @chessboard[0][4] = rook
      rook.position = [0,4]
    elsif direction == "castleright" && piece.team == "b"
      rook = @chessboard[0][7]
      king = @chessboard[0][4]
      @chessboard[0][7] = king
      king.position = [0,7]
      @chessboard[0][4] = rook
      rook.position = [0,4]
    elsif direction == "castleleft" && piece.team == "w"
      rook = @chessboard[7][0]
      king = @chessboard[7][4]
      @chessboard[7][0] = king
      king.position = [7,0]
      @chessboard[7][4] = rook
      rook.position = [7,4]
    elsif direction == "castleright" && piece.team == "w"
      rook = @chessboard[7][7]
      king = @chessboard[7][4]
      @chessboard[7][7] = king
      king.position = [7,7]
      @chessboard[7][4] = rook
      rook.position = [7,4]
    end
  end

  def execute_move(player_next, piece, board, capture)
    moves = piece.movement(board)
    original_position = piece.position
    if piece.class == WhitePawn && player_next == @en_passant_b
      board[player_next[0]][player_next[1]] = piece
      piece.position = player_next
      board[original_position[0]][original_position[1]] = nil
      board[player_next[0] + 1][player_next[1]] = nil
    elsif piece.class == BlackPawn && player_next == @en_passant_w
      board[player_next[0]][player_next[1]] = piece
      piece.position = player_next
      board[original_position[0]][original_position[1]] = nil
      board[player_next[0] - 1][player_next[1]] = nil
    elsif moves.include?(player_next)
      board[player_next[0]][player_next[1]] = piece
      piece.position = player_next
      board[original_position[0]][original_position[1]] = nil
    elsif capture.include?(player_next)
      if board[player_next[0]][player_next[1]].team == "w"
        @captured_piece = board[player_next[0]][player_next[1]]
        board[player_next[0]][player_next[1]] = piece
        piece.position = player_next
        board[original_position[0]][original_position[1]] = nil
      elsif board[player_next[0]][player_next[1]].team == "b"
        @captured_piece = board[player_next[0]][player_next[1]]
        board[player_next[0]][player_next[1]] = piece
        piece.position = player_next
        board[original_position[0]][original_position[1]] = nil
      end
    end

    if piece.class == WhitePawn && piece.position[0] == original_position[0] - 2
      @en_passant_w = [original_position[0] - 1, original_position[1]]
    elsif piece.class == BlackPawn && piece.position[0] == original_position[0] + 2
      @en_passant_b = [original_position[0] + 1, original_position[1]]
    end
  end
  
  def check(board)
    if @player == "w"
      remaining_black = @remaining_black.clone
      if @captured_piece != nil && @captured_piece.team == "b"
        remaining_black.delete(@captured_piece)
      end
      enemy_range = []
      w_king = @remaining_white.select { |piece| piece.piece == "king" } 
      remaining_black.each do |piece|
        piece_range = capture_by_type(piece, board)
        piece_range.each { |pos| enemy_range << pos unless pos == []}
      end
      if enemy_range.include?(w_king[0].position)
        return true
      else
        return false
      end
    else
      remaining_white = @remaining_white.clone
      if @captured_piece != nil && @captured_piece.team == "w"
        remaining_white.delete(@captured_piece)
      end
      enemy_range = []
      b_king = @remaining_black.select { |piece| piece.piece == "king" }
      remaining_white.each do |piece|
        piece_range = capture_by_type(piece, board)
        piece_range.each { |pos| enemy_range << pos unless pos == []}
      end
      if enemy_range.include?(b_king[0].position)
        return true
      else
        return false
      end
    end
  end

  def still_in_check?
    still_in_check = true
    until still_in_check == false
      copy_board = @chessboard.map(&:clone)
      puts "You are in check."
      chosen_piece = choose_move
      if chosen_piece == "save"
        return "save"
      end
      save_position = chosen_piece.position
      player_next = calculate_moves(chosen_piece)
      capture = capture_by_type(chosen_piece, copy_board)
      execute_move(player_next, chosen_piece, copy_board, capture)

      if check(copy_board) == false
        still_in_check = false
        update_remaining_pieces
        @chessboard = copy_board
        if chosen_piece.class == King || chosen_piece.class == Rook
          chosen_piece.move_count += 1
        end
      else
        chosen_piece.position = save_position
      end
      
    end
  end

  def in_checkmate?
    if @player == "w"
      @remaining_white.each do |piece|
        original_position = piece.position
        moves = piece.movement(@chessboard)
        capture = capture_by_type(piece, @chessboard)
        all_moves = moves.concat(capture)
        # Check if moves are legal or not:
         
        all_moves = legal_move?(all_moves, piece)
         
        all_moves.each do |move|
          copy_board = @chessboard.map(&:clone)
          execute_move(move, piece, copy_board, capture)
          if check(copy_board) == true
            piece.position = original_position
            next
          else
            piece.position = original_position
            return false
          end
        end
      end
    elsif @player == "b"
      @remaining_black.each do |piece|
        original_position = piece.position
        moves = piece.movement(@chessboard)
        capture = capture_by_type(piece, @chessboard)
        all_moves = moves.concat(capture)
        # Check if moves are legal or not:
         
        all_moves = legal_move?(all_moves, piece)
         
        all_moves.each do |move|
          copy_board = @chessboard.map(&:clone)
           
          execute_move(move, piece, copy_board, capture)
          if check(copy_board) == true
            piece.position = original_position
            next
          else
            piece.position = original_position
            return false
          end
        end
      end
    end
    
    return true
    
  end

  def reset_captured_piece
    @captured_piece = nil
  end

  def reset_en_passant
    if @player == "w"
      @en_passant_w = nil
    else
      @en_passant_b = nil
    end
  end

  def save(game, save_name)
    $stdout = File.open("game_one.yml", "w") 
    puts YAML::dump(game)
    $stdout.close
    $stdout = STDOUT
  end
end