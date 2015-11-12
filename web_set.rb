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
