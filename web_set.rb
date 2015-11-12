require "sinatra"
require "json"
require_relative "lib/game/play"

use Rack::Session::Pool
set :new_game, Game::Play.new

get "/" do
  session.clear
  session[:game] = settings.new_game
  erb :game
end

get "/game/start" do
  game = session[:game]

  game.board.face_up_initial_cards
  session[:board_cards] = game.board.board_cards

  { faceUpCards: session[:board_cards], index: 0 }.to_json
end
