require "spec_helper"

describe Game::Computer do
  before(:each) do
    @computer = Game::Computer.new
    @board = Game::Board.new
    @rules = Game::Rules.new
  end

  context "Find 'Set' from board cards" do
    it 'Return cards is set' do
      face_up_cards = [ {"color"=>"R", "shape"=>"S", "shading"=>"E", "number"=>"3"},
                        {"color"=>"P", "shape"=>"D", "shading"=>"F", "number"=>"3"},
                        {"color"=>"R", "shape"=>"D", "shading"=>"S", "number"=>"1"},
                        {"color"=>"P", "shape"=>"O", "shading"=>"F", "number"=>"2"},
                        {"color"=>"R", "shape"=>"O", "shading"=>"F", "number"=>"2"},
                        {"color"=>"P", "shape"=>"S", "shading"=>"E", "number"=>"3"},
                        {"color"=>"G", "shape"=>"S", "shading"=>"F", "number"=>"3"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"F", "number"=>"1"},
                        {"color"=>"G", "shape"=>"S", "shading"=>"S", "number"=>"3"},
                        {"color"=>"P", "shape"=>"D", "shading"=>"E", "number"=>"2"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"F", "number"=>"3"},
                        {"color"=>"P", "shape"=>"S", "shading"=>"E", "number"=>"2"} ]

      @board.board_cards = face_up_cards
      result = @computer.find_set(@board)

      expect(@rules.is_set?(result)).to be true
    end

    it 'Return cards is empty, when no set in board cards' do
      face_up_cards = [ {"color"=>"P", "shape"=>"S", "shading"=>"E", "number"=>"1"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"E", "number"=>"2"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"F", "number"=>"3"},
                        {"color"=>"G", "shape"=>"O", "shading"=>"E", "number"=>"2"},
                        {"color"=>"G", "shape"=>"O", "shading"=>"F", "number"=>"2"},
                        {"color"=>"G", "shape"=>"O", "shading"=>"F", "number"=>"3"},
                        {"color"=>"G", "shape"=>"S", "shading"=>"E", "number"=>"3"},
                        {"color"=>"G", "shape"=>"S", "shading"=>"S", "number"=>"3"},
                        {"color"=>"P", "shape"=>"O", "shading"=>"S", "number"=>"3"},
                        {"color"=>"R", "shape"=>"O", "shading"=>"S", "number"=>"1"},
                        {"color"=>"R", "shape"=>"S", "shading"=>"F", "number"=>"3"},
                        {"color"=>"R", "shape"=>"S", "shading"=>"S", "number"=>"3"} ]

      @board.board_cards = face_up_cards

      expect(@computer.find_set(@board)).to be_empty
    end
  end
end
