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

get "/game/rules" do
  game = session[:game]

  if game.rules.has_set?(game.board.board_cards)
    { set: true }.to_json
  else
    new_cards = game.board.face_up_new_cards

    { set: false, newCards: new_cards }.to_json
  end
end
