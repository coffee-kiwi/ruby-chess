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
require_relative '../lib/board'

RSpec.describe Board do 
  describe 'basic chess moves' do 
    subject(:board) {Board.new}
    context 'can make basic moves' do
      it 'players turn switches after every round' do
        board.change_player
        expect(board.player).to eql("b")
      end

      xit 'legal moves are displayed' do
        
      end

      xit 'pieces move to correct new places on chessboard' do
        
      end

      xit 'black pieces can capture other pieces' do
        
      end

      xit 'white pieces can capture black pieces' do
        
      end
    end
  end
end