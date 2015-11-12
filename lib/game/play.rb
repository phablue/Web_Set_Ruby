require_relative "board"
require_relative "rules"

module Game
  class Play
    attr_accessor :board
    attr_reader :rules

    def initialize
      @board = Game::Board.new
      @rules = Gane::Board.new(@board)
    end
  end
end
