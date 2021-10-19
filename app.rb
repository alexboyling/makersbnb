require 'sinatra/base'
require 'sinatra/reloader'
require './database_connection_setup'

class Makersbnb < Sinatra::Base
  enable :sessions
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    'Team Team MakersBnB'
  end
end