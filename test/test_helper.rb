require 'test/unit'
require 'rack/test'
require_relative '../landa'

ENV['RACK_ENV'] = 'test'

class Test::Unit::TestCase
  include Rack::Test::Methods
end

