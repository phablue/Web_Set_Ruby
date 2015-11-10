require "spec_helper"

describe Game::Board do
  before(:each) do
    @board = Game::Board.new
  end

  it "The number of deck cards is 81, when successed reading JSON file" do
    actual = @board.deck.size

    expect(actual).to eq 81
  end

  it "The number of faced up initial cards is 12 and included within the deck, when successed picking from the deck" do
    actual = @board.face_up_initial_cards

    expect(actual.size).to eq 12
    actual.each { |card| expect(@board.deck).to include card }
  end

  it "The number of deck cards is 69, when after faced up initial cards" do
    actual = @board.deck.size

    expect{ @board.face_up_initial_cards }.to change{ actual }.to( 69 ).from( 81 )
  end
end
