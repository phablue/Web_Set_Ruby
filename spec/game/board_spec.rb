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

    board = Game::Board.new
    actual.each { |card| expect(board.deck).to include card }
  end

  it "The number of deck cards is 69, when after faced up initial cards" do
    expect{ @board.face_up_initial_cards }.to change{ @board.deck.size }.to( 69 ).from( 81 )
  end

  it "The number of board cards is 12, when after faced up initial cards" do
    expect{ @board.face_up_initial_cards }.to change{ @board.board_cards.size }.to( 12 ).from( 0 )
  end

  it "The number of deck cards is 78, when after faced up new cards" do
    expect{ @board.face_up_new_cards }.to change{ @board.deck.size }.to( 78 ).from( 81 )
  end

  it "The number of board cards is 3, when after faced up new cards" do
    expect{ @board.face_up_new_cards }.to change{ @board.board_cards.size }.to( 3 ).from( 0 )
  end
end
