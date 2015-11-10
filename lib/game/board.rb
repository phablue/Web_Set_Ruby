require "json"

module Game
  class Board
    attr_accessor :deck

    def initialize
      @deck = get_cards
    end

    def get_cards
      file = File.read("cards.json")
      JSON.parse(file)
    end

    def face_up_cards
      @deck.sample(12)
    end
  end
end
