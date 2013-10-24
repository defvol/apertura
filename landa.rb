require 'rubygems'
require 'sinatra'
require 'mongo'
require 'mongo_mapper'
require 'json'
require 'rack-flash'
require 'i18n'
require 'rack/protection'

Dir[File.join(File.dirname(__FILE__), 'helpers', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each { |file| require file }

I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.yml').to_s]

configure do

  enable :sessions
  use Rack::Session::Cookie,
    :key => "rack.session.#{Time.now().to_i}",
    :path => '/',
    :expire_after => 900,
    :secret => (1..8).map { ('a'..'z').to_a[rand(26)] }.join

  if ENV['RACK_PROTECTION']
    use Rack::Protection::FormToken
    set :protection, :session => true
  end

  use Rack::Flash

  if ENV['MONGODB_URI'].nil?
    MongoMapper.database = "landa_#{ENV['RACK_ENV']}"
  else
    MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')
  end

end

configure :test do
  require 'rack_session_access'
  use RackSessionAccess::Middleware
end

configure :production do
  require 'newrelic_rpm'
end

helpers do

  def t(*args)
    I18n.t(*args)
  end

  def link_to(url, text = url, options = {})
    attributes = ""
    options.each do |key, value|
      attributes << key.to_s << '="' << value << '" '
    end
    "<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def csrf_input_tag
    %Q(<input type="hidden" name="authenticity_token" value="#{session[:csrf]}" />)
  end

  def pick_color
    session[:color_index] = (session[:color_index] || 0) ^ 1
    ["green", "purple"][session[:color_index]]
  end

end

before do
  locale = params[:locale]
  I18n.locale = locale || :es
end

not_found do
  send_file File.expand_path('404.html', settings.public_folder)
end

get '/' do
  session[:color] = pick_color
  options = Poll.new.pick(2)
  haml :index, locals: { options: options }
end

get '/options.json' do
  Option.where(:parent_uid.exists => false).all.to_json
end

get '/options/:uid.json' do
  Option.where(parent_uid: params[:uid].to_i).to_json
end

get '/answers.json' do
  Answer.all.to_json
end

post '/respuestas' do
  option = Option.where(pseudo_uid: params[:selected].to_i).all.first
  # Check if sent option exists in our database
  unless option.nil?
    # Embed selected option in the answers record
    selected_option = SelectedOption.new(JSON.parse(option.to_json))
    Answer.create(selected_option: selected_option)
  end

  flash[:finish] = true
  options = Poll.new.pick(2, params[:selected].to_i)
  if options.empty?
    redirect '/'
  else
    haml :index, locals: { options: options }
  end
end

get '/resultados' do
  haml :results
end

get '/votes.json' do
  Answer.votes_by_category.to_json
end

get '/privacidad' do
  haml :privacy
end

post '/registro' do
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

get '/requests.json' do
  User.data_requests.to_json
end

get '/categories.json' do
  User.data_requests_by_category.to_json
end

get '/daily.json' do
  User.data_requests_by_day.to_json
end

