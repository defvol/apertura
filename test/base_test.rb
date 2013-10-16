require_relative './test_helper'

class BaseTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.body.include?('body')
  end

  def test_that_email_cant_be_blank
    post '/signup'
    assert_not_equal last_response.status, 200
  end

  def test_email_uniqueness
    delete_some_user
    2.times { post '/signup', { :email => some_email } }
    assert_not_equal last_response.status, 200
  end

  def test_email_validation
    post '/signup', { email: 'bar' }
    assert_not_equal last_response.status, 200
  end

  def test_embedded_data_request
    delete_some_user

    request = { description: "RAW DATA NOW", category: "Education" }
    user = User.new(email: some_email, data_requests:[request])
    assert user.save
  end

  def test_it_wont_count_missing_data_requests
    user = User.new(email: some_email, data_requests:nil)
    assert_equal 0, user.data_requests.count

    user = User.new(email: some_email, data_requests:[])
    assert_equal 0, user.data_requests.count
  end

  def test_it_wont_allow_empty_data_request
    delete_some_user

    user = User.new(email: some_email, data_requests:[{}])
    user.save
    assert_equal 1, user.data_requests.last.errors.size
  end

  def test_answer_form_submit
    count_before = Answer.count
    post '/answers', { selected: '1' }
    assert_equal count_before + 1, Answer.count
  end

end

