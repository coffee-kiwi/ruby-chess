# frozen_string_literal: true
require 'pry-byebug'
require_relative '../lib/board'
require_relative '../lib/all_pieces'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/rook'

RSpec.describe King do
  describe 'Evaluates possible moves' do
    subject(:king) { King.new("w", [7,4]) }
    subject(:king_two) { King.new("w", [6,4]) }
    subject(:board) { Board.new }
    context 'will return legal moves' do
      it 'Can return no moves on the first turn' do
        board.chessboard[7][3] = King.new("w", [7,3])
        board.chessboard[7][5] = King.new("w", [7,5])
        board.chessboard[6][3] = King.new("w", [6,3])
        board.chessboard[6][4] = King.new("w", [6,4])
        board.chessboard[6][5] = King.new("w", [6,5])
        moves = king.movement(board.chessboard)
        expect(moves).to eql([])
      end
      it 'Can return moves in all directions if no pieces surround it' do
        moves = king_two.movement(board.chessboard)
        expect(moves).to eql([[5,4], [5,5], [6,5], [7,5], [7,4], [7,3], [6,3], [5,3]])
      end

      it 'Can return array of capturable pieces' do
        board.chessboard[7][3] = King.new("b", [7,3])
        board.chessboard[7][5] = King.new("w", [7,5])
        board.chessboard[6][3] = King.new("b", [6,3])
        board.chessboard[6][4] = King.new("b", [6,4])
        board.chessboard[6][5] = King.new("b", [6,5])
        capture = king.capturable(board.chessboard)
        expect(capture).to eql([[6,4], [6,5], [7,3], [6,3]])
      end
    end

    context 'Castling' do
      it 'Can find whether castling is a legal move' do
        king = King.new("w", [7,4])
        rook = Rook.new("w", [7,0])
        board.chessboard[7][4] = king
        board.chessboard[7][0] = rook
        moves = king.movement(board.chessboard)
        expect(moves).to include("castleleft")
      end
      it 'Can correctly castle to the left' do
        king = King.new("w", [7,4])
        rook = Rook.new("w", [7,0])
        rook2 = Rook.new("w", [0,7])
        board.chessboard[7][4] = king
        board.chessboard[7][0] = rook
        moves = king.movement(board.chessboard)
        board.castling("castleleft", king)
        expect(king.position).to eql([7,0])
      end
      it 'Can correctly castle to the right' do
        king = King.new("b", [0,4])
        rook = Rook.new("b", [0,7])
        rook2 = Rook.new("b", [0,0])
        board.chessboard[0][4] = king
        board.chessboard[0][7] = rook
        board.chessboard[0][0] = rook2
        moves = king.movement(board.chessboard)
        board.castling("castleright", king)
        expect(king.position).to eql([0,7])
      end
      it 'Does not allow castling when the king has moved' do
        king = King.new("b", [0,4])
        rook = Rook.new("b", [0,7])
        rook2 = Rook.new("b", [0,0])
        board.chessboard[0][4] = king
        board.chessboard[0][7] = rook
        board.chessboard[0][0] = rook2
        king.move_count += 1
        expect(king.castle_left?(board.chessboard)).to_not be(true)
      end
    end
  end
end