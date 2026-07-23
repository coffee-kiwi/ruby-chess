# frozen_string_literal: true
require 'pry-byebug'
require_relative '../lib/board'
require_relative '../lib/all_pieces'
require_relative '../lib/pieces/queen'

RSpec.describe Queen do
  describe 'Evaluates possible moves' do
    subject(:queen) { Queen.new("w", [7,3]) }
    subject(:queen_mid) { Queen.new("w", [3,3]) }
    subject(:board) { Board.new }
    context 'will return legal moves' do
      it 'Can return no moves on the first turn' do
        board.chessboard[7][2] = Queen.new("w", [7,2])
        board.chessboard[7][4] = Queen.new("w", [7,4])
        board.chessboard[6][2] = Queen.new("w", [6,2])
        board.chessboard[6][3] = Queen.new("w", [6,3])
        board.chessboard[6][4] = Queen.new("w", [6,4])
        moves = queen.movement(board.chessboard)
        expect(moves).to eql([])
      end
      it 'Can return moves in all directions if no pieces surround it' do
        board.chessboard[0][3] = Queen.new("w", [0,3])
        board.chessboard[1][5] = Queen.new("w", [1,5])
        board.chessboard[3][4] = Queen.new("w", [3,4])
        board.chessboard[6][6] = Queen.new("w", [6,6])
        board.chessboard[6][0] = Queen.new("w", [6,0])
        board.chessboard[3][0] = Queen.new("w", [3,0])
        board.chessboard[0][0] = Queen.new("w", [0,0])
        moves = queen_mid.movement(board.chessboard)
        expect(moves).to eql([[2,3], [1,3], [4,3], [5,3], [6,3], [7,3], [3,2], [3,1], [2,2], [1,1], [2,4], [4,2], [5,1], [4,4], [5,5]])
      end

      it 'Can return array of capturable pieces' do
        board.chessboard[0][3] = Queen.new("b", [0,3])
        board.chessboard[1][5] = Queen.new("b", [1,5])
        board.chessboard[3][4] = Queen.new("b", [3,4])
        board.chessboard[6][6] = Queen.new("w", [6,6])
        board.chessboard[0][0] = Queen.new("b", [0,0])
        capture = queen_mid.capturable(board.chessboard)
        expect(capture).to eql([[0,3], [3,4],[0,0],[1,5]])
      end
    end

  end
end