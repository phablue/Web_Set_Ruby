require "json"

module Game
  class Board
    attr_accessor :deck

    def initialize
      @deck = shuffled_cards
    end

    def get_cards
      file = File.read("cards.json")
      JSON.parse(file).shuffle!
    end

    def shuffled_cards
      get_cards.shuffle
    end

    def face_up_initial_cards
      @deck = @deck - @deck[0..11]
      @deck[0..11]
    end

    def new_face_up_cards
      @deck[0..2]
    end
  end
end
