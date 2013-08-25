require 'rubygems'
require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'json'
require 'rack-flash'

Dir[File.join(File.dirname(__FILE__), 'helpers', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }

enable :sessions
use Rack::Flash

configure do
  MongoMapper.database = "landa_#{ENV['RACK_ENV']}"
end

not_found do
  send_file File.expand_path('404.html', settings.public_folder)
end

get '/' do
  haml :index
end

post '/signup' do
  data_requests = params[:'data-requests'] || []

  # Recursive trimming to clean up empty hashes and values
  data_requests.each { |req_hash| req_hash.trim }.trim

  user = User.new(email: params[:email], data_requests: data_requests.map { |r| DataRequest.new(r) })
  if user.save
    haml :confirmation, locals: { email: user.email }
  else
    flash[:error] = user.errors.full_messages.join(",")
    redirect "/"
  end
end



