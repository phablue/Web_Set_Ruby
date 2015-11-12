require "sinatra"
require "json"
require_relative "lib/game/play"

use Rack::Session::Pool
set :new_game, Game::Play.new
