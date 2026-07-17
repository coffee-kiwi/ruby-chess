# frozen_string_literal: true
require 'pry-byebug'
require_relative '../lib/board'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/white_pawn'
require_relative '../lib/pieces/black_pawn'  

RSpec.describe Board do 
  describe 'setting up the board' do
    subject(:board) {Board.new}
    context 'can set up different pieces' do
    xit 'Can set up all black pawns' do
    end

    xit 'Can set up all white pawns' do
      board = Boa
    end

    xit 'Can set up bishops' do
      
    end
    xit 'Can set up kings' do
      
    end

    xit 'Can set up queens' do
      
    end

    xit 'Can set up knights' do 
      
    end

    xit 'Can set up rooks' do
      
    end
  end
  end

  describe 'checking for check' do 
    subject(:board) { Board.new }
    context 'will find check when it is true' do
      it 'finds check from rook' do
        board.chessboard[3][3] = King.new("b", [3,3])
        board.remaining_black << board.chessboard[3][3]
        board.chessboard[3][7] = Rook.new("w", [3,7])
        board.remaining_white << board.chessboard[3][7]
        value = board.check(board.chessboard)
        expect(value).to be(true)
      end

      it 'returns false with no check' do
        board.chessboard[3][3] = King.new("b", [3,3])
        board.remaining_black << board.chessboard[3][3]
        board.chessboard[4][7] = Rook.new("w", [4,7])
        board.remaining_white << board.chessboard[4][7]
        value = board.check(board.chessboard)
        expect(value).to be(false)
      end

      it 'Does not accept illegal moves' do
        board.chessboard[6][7] = Rook.new("b", [6,7])
        board.remaining_black << board.chessboard[6][7]
        king = King.new("w", [7,4])
        board.chessboard[7][4] = king
        board.remaining_white << board.chessboard[7][4]
        moves = king.movement(board.chessboard)
        legal_moves = board.legal_move?(moves, king, "w")
        board.display_board
        puts legal_moves
        expect(legal_moves).to eql([[7,5],[7,3]])
      end
    end

    context 'When checking for checkmate' do
      it 'Returns true when checkmate is reached for black' do
        board.chessboard[1][0] = Queen.new("w", [1,0])
        board.remaining_white << board.chessboard[1][0]
        board.chessboard[0][0] = Rook.new("w", [0,0])
        board.remaining_white << board.chessboard[0][0]
        board.chessboard[0][4] = King.new("b", [0,4])
        board.remaining_black << board.chessboard[0][4]
        checkmate = board.in_checkmate?("b")
        expect(checkmate).to be(true)
      end
      
      it 'Returns true when checkmate is reached for white' do
        board.chessboard[1][0] = Queen.new("b", [1,0])
        board.remaining_black << board.chessboard[1][0]
        board.chessboard[0][0] = Rook.new("b", [0,0])
        board.remaining_black << board.chessboard[0][0]
        board.chessboard[0][4] = King.new("w", [0,4])
        board.remaining_white << board.chessboard[0][4]
        checkmate = board.in_checkmate?("w")
        expect(checkmate).to be(true)
      end
  

      it 'Returns false when a player can capture to get out of checkmate' do
        board.chessboard[1][0] = Queen.new("w", [1,0])
        board.remaining_white << board.chessboard[1][0]
        board.chessboard[0][3] = Rook.new("w", [0,3])
        board.remaining_white << board.chessboard[0][3]
        board.chessboard[0][4] = King.new("b", [0,4])
        board.remaining_black << board.chessboard[0][4]
        checkmate = board.in_checkmate?("b")
        expect(checkmate).to be(false)
      end

      it 'Returns false when a player can move to get out of checkmate' do
        board.chessboard[1][0] = Queen.new("w", [1,0])
        board.remaining_white << board.chessboard[1][0]
        board.chessboard[6][4] = Rook.new("w", [6,4])
        board.remaining_white << board.chessboard[6][4]
        board.chessboard[1][4] = King.new("b", [1,4])
        board.remaining_black << board.chessboard[1][4]
        checkmate = board.in_checkmate?("b")
        expect(checkmate).to be(false)
      end

      it 'Returns false when another piece can capture to get out of checkmate' do
        board.chessboard[0][0] = Queen.new("b", [0,0])
        board.remaining_black << board.chessboard[0][0]
        board.chessboard[6][0] = Rook.new("w", [6,0])
        board.remaining_white << board.chessboard[6][0]
        board.chessboard[0][4] = King.new("w", [0,4])
        board.remaining_white << board.chessboard[0][4]
        checkmate = board.in_checkmate?("w")
        expect(checkmate).to be(false)
      end

      it 'Returns false when another piece can block to get out of checkmate' do
        board.chessboard[2][0] = Queen.new("w", [2,0])
        board.remaining_white << board.chessboard[2][0]
        board.chessboard[1][2] = BlackPawn.new("b", [1,2])
        board.remaining_black << board.chessboard[1][2]
        board.chessboard[2][4] = King.new("b", [2,4])
        board.remaining_black << board.chessboard[2][4]
        checkmate = board.in_checkmate?("b")
        expect(checkmate).to be(false)
      end
    end
  end

end