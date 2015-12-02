module Game
  class Computer
    def initialize
      @rules = Game::Rules.new
    end

    def find_set(board)
      set = []
      board.board_cards.combination(3) do |cards|
        if @rules.is_set?(abbreviation(cards))
          set = abbreviation(cards)
          break
        end
      end
      set
    end

    def abbreviation(cards)
      cards.inject([]) { |arr, card| arr << card.values.join }
    end
  end
end
