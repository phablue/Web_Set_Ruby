module Game
  class Play
    def initialize
      @board = Game::Board.new
      @face_up_cards = @board.initial_face_up_cards
      @rules = Gane::Board.new(face_up_cards)
    end
  end
end
