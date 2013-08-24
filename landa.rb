require 'rubygems'
require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'json'
require 'rack-flash'
require_relative 'models/user'

enable :sessions
use Rack::Flash

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
  user = User.new(email: params[:email])
  if user.save
    haml :confirmation, locals: { email: user.email }
  else
    flash[:error] = user.errors.full_messages.join(",")
    redirect "/"
  end
end

