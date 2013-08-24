require_relative './test_helper'

class BaseTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.body.include?('Welcome')
  end

  def test_it_validates_email
    post '/api/user', { email: 'foo' }.to_json
    assert_not_equal last_response.status, 200
  end
end

