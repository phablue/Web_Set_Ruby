require "json"

module Game
  class Board
    attr_accessor :deck, :board_cards

    def initialize
      @deck = shuffled_cards
      @board_cards = []
    end

    def get_cards
      file = File.read("cards.json")
      JSON.parse(file)
    end

    def shuffled_cards
      get_cards.shuffle
    end

    def face_up_initial_cards
      cards = @deck[0...12]

      remove_from_deck(cards)
      add_to_board(cards)

      cards
    end

    def face_up_new_cards
      cards = @deck[0...3]

      remove_from_deck(cards)
      add_to_board(cards)

      cards
    end

    def remove_from_deck(cards)
      @deck -= cards
    end

    def add_to_board(cards)
      @board_cards += cards
    end

    def remove_from_board(cards)
      @board_cards -= cards
    end
  end
end
