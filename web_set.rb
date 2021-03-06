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

  if game.rules.has_set?(game.board)
    { set: true }.to_json
  else
    new_cards = game.board.face_up_new_cards

    { set: false, newCards: new_cards }.to_json
  end
end

post "/game/rules" do
  game = session[:game]
  chosen_cards = params["choice"]
  session[:current_plyaer] = "player"

  if game.rules.is_set?(chosen_cards)
    game.board.remove_from_board(chosen_cards)
    new_cards = game.board.face_up_new_cards

    { set: true, chosenCards: chosen_cards, newCards: new_cards, currentPlayer: "player" }.to_json
  else
    { set: false, currentPlayer: "player" }.to_json
  end
end

get "/game/computer" do
  game = session[:game]
  session[:current_plyaer] = "computer"

  chosen_cards = game.computer.find_set(game.board)

  game.board.remove_from_board(chosen_cards)
  new_cards = game.board.face_up_new_cards

  { set: true, chosenCards: chosen_cards, newCards: new_cards, currentPlayer: "computer" }.to_json
end

get "/game/end" do
  game = session[:game]
  current_player = session[:current_plyaer]
  player = params["player"]
  computer = params["computer"]

  if game.rules.game_over?(game.board)
    player_point = game.rules.point_calculator(player)
    computer_point = game.rules.point_calculator(computer)

    { gameOver: true, playerPoint: player_point, computerPoint: computer_point }.to_json
  else
    { gameOver: false, currentPlayer: current_player }.to_json
  end
end

get "/game/restart" do
  redirect "/"
end

