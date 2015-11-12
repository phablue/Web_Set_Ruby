module Game
  class Rules
    def initialize(board)
      @board = board
    end

    def has_set?
      attributes = { "color" => "GPR", "shape" => "DOS", "shading" => "EFS", "number" => "123" }
      standard = Hash.new

      for i in 0...(@board.board_cards.size)
        for j in (i + 1)...(@board.board_cards.size)
          attributes.each_pair do | key, value |
            if @board.board_cards[i][key] == @board.board_cards[j][key]
              standard[key] = @board.board_cards[i][key]
            else
              standard[key] = value.delete(@board.board_cards[i][key] + @board.board_cards[j][key])
            end
          end

          matches = @board.board_cards.select{ |card| card == standard }

          unless matches.empty?
            puts [ @board.board_cards[i].values.join, @board.board_cards[j].values.join, matches[0].values.join ]
            return true
          end
        end
      end
      false
    end

    def is_set?(chosen_cards)
      for i in 0...4
        cards_attr = get_attribute(chosen_cards, i)
        return false unless is_same_or_different?(cards_attr)
      end
      true
    end

    def is_same_or_different?(cards_attr)
      cards_attr.size != 2
    end

    def get_attribute(cards, attr_index)
      [ cards[0][attr_index], cards[1][attr_index], cards[2][attr_index] ].uniq.join
    end

    def game_over?
      @board.deck.size == 0 && !(has_set?)
    end
  end
end
