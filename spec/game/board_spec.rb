require "spec_helper"

describe Game::Board do
  before(:each) do
    @board = Game::Board.new
  end

  it "Deck size is 81, when successed reading JSON file" do
    expected = 81
    actual = @board.deck.size

    expect(actual).to eq expected
  end

  it "Face up cards are totall 12 and included within the deck, when successed picking from the deck" do
    expected = 12
    actual = @board.face_up_cards

    expect(actual.size).to eq expected
    actual.each { |card| expect(@board.deck).to include card }
  end
end
