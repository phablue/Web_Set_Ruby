require "spec_helper"

describe Game::Rules do
  before(:each) do
    @board = Game::Board.new
    @rules = Game::Rules.new(@board)
  end

  context "Check board of cards have 'set'" do
    it "Return 'true', when face-up cards have 'set'" do
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
      expect(@rules.has_set?).to be true
    end

    it "Return 'true', when face-up cards have 'set'" do
      face_up_cards = [ {"color"=>"P", "shape"=>"O", "shading"=>"E", "number"=>"2"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"S", "number"=>"1"},
                        {"color"=>"R", "shape"=>"S", "shading"=>"E", "number"=>"3"},
                        {"color"=>"R", "shape"=>"D", "shading"=>"E", "number"=>"1"},
                        {"color"=>"R", "shape"=>"O", "shading"=>"S", "number"=>"2"},
                        {"color"=>"R", "shape"=>"S", "shading"=>"S", "number"=>"2"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"E", "number"=>"1"},
                        {"color"=>"G", "shape"=>"O", "shading"=>"S", "number"=>"1"},
                        {"color"=>"R", "shape"=>"O", "shading"=>"E", "number"=>"1"},
                        {"color"=>"P", "shape"=>"O", "shading"=>"S", "number"=>"1"},
                        {"color"=>"G", "shape"=>"S", "shading"=>"S", "number"=>"1"},
                        {"color"=>"G", "shape"=>"D", "shading"=>"F", "number"=>"1"} ]

      @board.board_cards = face_up_cards
      expect(@rules.has_set?).to be true
    end

    it "Return 'false', when face-up cards dont have 'set'" do
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
      expect(@rules.has_set?).to be false
    end
  end

  context "Check a user choice is 'set'" do
    before(:each) do
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
      @rules.has_set?
    end

    it "Return 'true', when a user choie is set" do
      user_choice = ["RDS1", "ROF2", "RSE3"]

      expect(@rules.is_set?(user_choice)).to be true
    end

    it "Return 'true', when a user choie is set" do
      user_choice = ["RDS1", "PDE2", "GDF3"]

      expect(@rules.is_set?(user_choice)).to be true
    end

    it "Return 'false', when a user choie isnt set" do
      user_choice = ["RDS1", "RDS2", "GDF3"]

      expect(@rules.is_set?(user_choice)).to be false
    end
  end
end
