require "sinatra"
require "json"
require_relative "lib/game/play"

use Rack::Session::Pool

get "/" do
  session.clear
  erb :game
end

get "/game/start" do
  session[:game] = Game::Play.new
  status 200
end

get "/game/board" do
  game = session[:game]

  game.board.face_up_initial_cards

  { faceUpCards: game.board.board_cards, index: 0 }.to_json
end

get "/game/rules" do
  game = session[:game]

  if game.rules.has_set?
    { set: true }.to_json
  else
    new_cards = game.board.face_up_new_cards

    { set: false, newCards: new_cards }.to_json
  end
end

post "/game/rules" do
  game = session[:game]
  chosen_cards = params["choice"].sort

  if game.rules.is_set?(chosen_cards)
    game.board.remove_from_board(chosen_cards)
    new_cards = game.board.face_up_new_cards

    { set: true, chosenCards: chosen_cards, newCards: new_cards }.to_json
  else
    { set: false }.to_json
  end
end

get "/game/end" do
  game = session[:game]

  if game.rules.game_over?
    { gameOver: true }.to_json
  else
    { gameOver: false }.to_json
  end
end

get "/game/restart" do
  redirect "/"
end

