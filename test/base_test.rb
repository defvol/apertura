require_relative './test_helper'

class BaseTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.body.include?('Welcome')
  end

  def test_that_email_cant_be_blank
    post '/signup'
    assert_not_equal last_response.status, 200
  end

  def test_email_uniqueness
    2.times { post '/signup', { :email => 'test@foo.bar' } }
    assert_not_equal last_response.status, 200
  end

  def test_email_validation
    post '/signup', { email: 'bar' }
    assert_not_equal last_response.status, 200
  end

  def test_embedded_data_request
    email = "test@foo.bar"

    # Clean up
    user = User.find_by_email(email)
    user.delete if user

    request = { description: "RAW DATA NOW", category: "Education" }
    user = User.new(email: email, data_requests:[request])
    assert user.save
  end
end

