require "json"

module Game
  class Board
    attr_accessor :board_cards, :deck

    def initialize
      @deck = shuffled_cards
      @deck = [ {"color"=>"R", "shape"=>"S", "shading"=>"E", "number"=>"3"},
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
      @board_cards -= convert_to_hash(cards.sort)
    end

    def convert_to_hash(cards)
      convert = []
      cards.each do |card|
        convert << { "color" => card[0], "shape" => card[1], "shading" => card[2], "number" => card[3] }
      end
      convert
    end
  end
end
