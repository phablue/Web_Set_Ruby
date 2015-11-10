module Game
  class Rules
    def initialize(board)
      @board = board
      @sets = []
    end

    def has_set?
      attributes = { "color" => "GPR", "shape" => "DOS", "shading" => "EFS", "number" => "123" }
      standard = Hash.new

      for i in 0...12
        for j in (i + 1)...12
          attributes.each_pair do | key, value |
            if @board[i][key] == @board[j][key]
              standard[key] = @board[i][key]
            else
              standard[key] = value.delete(@board[i][key] + @board[j][key])
            end
          end

          matches = @board.select{ |card| card == standard }

          unless matches.empty?
            @sets  << add_matches_keyword(@board[i], @board[j], matches)
          end
        end
      end
      @sets.size != 0
    end

    def is_set?(chosen_cards)
      @sets.include?(chosen_cards)
    end

    def add_matches_keyword(card1, card2, card3)
      [ card1.values.join, card2.values.join, card3[0].values.join ]
    end
  end
end
