# frozen_string_literal: true
require 'pry-byebug'
require_relative '../lib/all_pieces'
require_relative '../lib/board'
require_relative '../lib/pieces/black_pawn'
require_relative '../lib/pieces/white_pawn'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'

RSpec.describe BlackPawn do
  describe 'Evaluates possible moves' do
    subject(:pawn_two) { BlackPawn.new("b", [1,2]) }
    subject(:pawn_three) { BlackPawn.new("b", [2,3]) }
    subject(:board) { Board.new }
    context 'will calculate only legal moves under basic circumstances' do
      it 'can move 1 or 2 spaces if in original start position' do
        moves = pawn_two.movement(board.chessboard)
        expect(moves).to eql([[2,2], [3,2]])
      end

      it 'can move 1 space forward when not in start position' do
        moves = pawn_three.movement(board.chessboard)
        expect(moves).to eql([[3,3]])
      end

      it 'cannot move forward when space in front is blocked' do
        board.chessboard[2][2] = BlackPawn.new("b", [3,2])
        moves = pawn_two.movement(board.chessboard)
        expect(moves).to eql([]) 
      end

      it 'can move diagonally 1 space to take an enemy piece' do
        board.chessboard[3][2] = WhitePawn.new("w", [3,2])
        capture = pawn_three.capturable(board.chessboard, @en_passant_w)
        expect(capture).to eql([[3,2]])
      end
    end

    context 'when pawn reaches the other side' do
      it 'may be switched for a queen' do
        pawn = BlackPawn.new( "b", [7, 3] )
        board.chessboard[7][3] = pawn
        allow(pawn).to receive(:gets).and_return("queen\n")

        pawn.upgrade(board.chessboard)
        expect(board.chessboard[7][3]).to be_a(Queen)
      end

      it 'may be switched for a rook' do
        pawn = BlackPawn.new( "b", [7, 3] )
        board.chessboard[7][3] = pawn
        allow(pawn).to receive(:gets).and_return("rook\n")

        pawn.upgrade(board.chessboard)
        expect(board.chessboard[7][3]).to be_a(Rook)
      end

      it 'will not run upgrade if pawn is not in last row' do
        pawn = BlackPawn.new( "b", [6, 3] )
        board.chessboard[6][3] = pawn
        pawn.upgrade(board.chessboard)
        expect(board.chessboard[6][3]).to be_a(BlackPawn)
      end

      it 'prompts until correct input is received' do
        pawn = BlackPawn.new( "b", [7, 3] )
        board.chessboard[7][3] = pawn
        allow(pawn).to receive(:gets).and_return("banana\n", "fish\n", "knight\n")
        pawn.upgrade(board.chessboard)

        expect(board.chessboard[7][3]).to be_a(Knight)
      end
    end

    context 'for en passant' do 
      it 'can add en passant location to capture array' do
        board.set_up_chessboard
        black = BlackPawn.new("b", [4,3])
        white = WhitePawn.new("w", [6,4])
        board.chessboard[6][4] = white
        board.chessboard[4][3] = black
        capture_white = white.capturable(board.chessboard, board.en_passant_b)
        board.execute_move([4,4], white, board.chessboard, capture_white)
        capture_black = black.capturable(board.chessboard, board.en_passant_w)
        expect(capture_black).to eql([[5,4]])

      end

      it 'can capture via en passant' do
        board.set_up_chessboard
        white = WhitePawn.new("w", [6,4])
        board.chessboard[6][4] = white
        black = BlackPawn.new("b", [4,3])
        board.chessboard[4][3] = black
        capture_white = white.capturable(board.chessboard, board.en_passant_b)
        board.execute_move([4,4], white, board.chessboard, capture_white)
        capture_black = black.capturable(board.chessboard, board.en_passant_w)
        board.execute_move([5,4], black, board.chessboard, capture_black)
        expect(board.chessboard[4][4]).to be(nil)
      end
    end

  end
end