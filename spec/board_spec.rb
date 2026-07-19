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
    it 'Can set up all black pawns' do
      board.set_up_chessboard
      expect(board.chessboard[1][3]).to be_a(BlackPawn)
    end

    it 'Can set up a white pawns' do
      board.set_up_chessboard
      expect(board.chessboard[6][3]).to be_a(WhitePawn)
    end

    it 'Can set up bishops' do
      board.set_up_chessboard
      expect(board.chessboard[7][2]).to be_a(Bishop)
    end
    it 'Can set up kings' do
      board.set_up_chessboard
      expect(board.chessboard[0][4]).to be_a(King)      
    end

    it 'Can set up queens' do
      board.set_up_chessboard
      expect(board.chessboard[7][3]).to be_a(Queen)      
    end

    it 'Can set up knights' do 
      board.set_up_chessboard
      expect(board.chessboard[0][1]).to be_a(Knight)
    end

    it 'Can set up rooks' do
      board.set_up_chessboard
      expect(board.chessboard[0][7]).to be_a(Rook)
    end
  end
  end

  describe 'checking for check' do 
    subject(:board) { Board.new }
    context 'will find check when it is true' do
      it 'finds check from rook' do
        king = King.new("w", [3,3])
        board.chessboard[3][3] = king
        board.remaining_white << king
        rook = Rook.new("b", [3,7])
        board.chessboard[3][7] = rook
        board.remaining_black << rook
        value = board.check(board.chessboard)
        expect(value).to be(true)
      end

      it 'returns false when not in check' do
        board.chessboard[3][3] = King.new("w", [3,3])
        board.remaining_white << board.chessboard[3][3]
        board.chessboard[4][7] = Rook.new("b", [4,7])
        board.remaining_black << board.chessboard[4][7]
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
        legal_moves = board.legal_move?(moves, king)
        board.display_board
        puts legal_moves
        expect(legal_moves).to eql([[7,5],[7,3]])
      end
    end

    context 'When checking for checkmate' do
      it 'Returns true when checkmate is reached for black' do
        board.change_player
        board.chessboard[1][0] = Queen.new("w", [1,0])
        board.remaining_white << board.chessboard[1][0]
        board.chessboard[0][0] = Rook.new("w", [0,0])
        board.remaining_white << board.chessboard[0][0]
        board.chessboard[0][4] = King.new("b", [0,4])
        board.remaining_black << board.chessboard[0][4]
        checkmate = board.in_checkmate?
        expect(checkmate).to be(true)
      end
      
      it 'Returns true when checkmate is reached for white' do
        board.chessboard[1][0] = Queen.new("b", [1,0])
        board.remaining_black << board.chessboard[1][0]
        board.chessboard[0][0] = Rook.new("b", [0,0])
        board.remaining_black << board.chessboard[0][0]
        board.chessboard[0][4] = King.new("w", [0,4])
        board.remaining_white << board.chessboard[0][4]
        checkmate = board.in_checkmate?
        expect(checkmate).to be(true)
      end
  

      it 'Returns false when a player can capture to get out of checkmate' do
        board.change_player
        board.chessboard[1][0] = Queen.new("w", [1,0])
        board.remaining_white << board.chessboard[1][0]
        board.chessboard[0][3] = Rook.new("w", [0,3])
        board.remaining_white << board.chessboard[0][3]
        board.chessboard[0][4] = King.new("b", [0,4])
        board.remaining_black << board.chessboard[0][4]
        checkmate = board.in_checkmate?
        expect(checkmate).to be(false)
      end

      it 'Returns false when a player can move to get out of checkmate' do
        board.change_player
        board.chessboard[1][0] = Queen.new("w", [1,0])
        board.remaining_white << board.chessboard[1][0]
        board.chessboard[6][4] = Rook.new("w", [6,4])
        board.remaining_white << board.chessboard[6][4]
        board.chessboard[1][4] = King.new("b", [1,4])
        board.remaining_black << board.chessboard[1][4]
        checkmate = board.in_checkmate?
        expect(checkmate).to be(false)
      end

      it 'Returns false when another piece can capture to get out of checkmate' do
        board.chessboard[0][0] = Queen.new("b", [0,0])
        board.remaining_black << board.chessboard[0][0]
        board.chessboard[6][0] = Rook.new("w", [6,0])
        board.remaining_white << board.chessboard[6][0]
        board.chessboard[0][4] = King.new("w", [0,4])
        board.remaining_white << board.chessboard[0][4]
        checkmate = board.in_checkmate?
        expect(checkmate).to be(false)
      end

      it 'Returns false when another piece can block to get out of checkmate' do
        board.change_player
        board.chessboard[2][0] = Queen.new("w", [2,0])
        board.remaining_white << board.chessboard[2][0]
        board.chessboard[1][2] = BlackPawn.new("b", [1,2])
        board.remaining_black << board.chessboard[1][2]
        board.chessboard[2][4] = King.new("b", [2,4])
        board.remaining_black << board.chessboard[2][4]
        checkmate = board.in_checkmate?
        expect(checkmate).to be(false)
      end
    end
  end

end