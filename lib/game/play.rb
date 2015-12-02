require_relative "board"
require_relative "rules"
require_relative "computer"

module Game
  class Play
    attr_accessor :board
    attr_reader :rules, :computer

    def initialize
      @board = Game::Board.new
      @rules = Game::Rules.new
      @computer = Game::Computer.new
    end
  end
end
