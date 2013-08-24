require 'rubygems'
require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'json'
require_relative 'models/user'

configure do
  MongoMapper.database = 'landa'
end

not_found do
  send_file File.expand_path('404.html', settings.public_folder)
end

get '/' do
  haml :index
end

post '/signup' do
  user = User.create(email: params[:email])
  haml :confirmation, locals: { email: user.email }
end

