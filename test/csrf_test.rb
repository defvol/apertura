require_relative './test_helper'

class CsrfTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def setup
    Rack::Attack.clear!
  end

  # NO TOKEN

  def test_signup_fails_without_token
    delete_some_user
    user_count = User.count
    post('/registro', { :email => some_email })
    assert_not_equal 200, last_response.status
    assert_equal user_count, User.count
  end

  def test_answer_fails_without_token
    answer_count = Answer.count
    post('/respuestas', { selected: '1' })
    assert_not_equal 200, last_response.status
    assert_equal answer_count, Answer.count
  end

  # TOKEN MISMATCH

  def test_signup_fails_with_token_mismatch
    delete_some_user
    user_count = User.count
    post('/registro', { :email => some_email, :authenticity_token => 'bar' })
    assert_not_equal 200, last_response.status
    assert_equal user_count, User.count
  end

  def test_answer_fails_with_token_mismatch
    answer_count = Answer.count
    post('/respuestas', { selected: '1', :authenticity_token => 'bar' })
    assert_not_equal 200, last_response.status
    assert_equal answer_count, Answer.count
  end

  # USING TOKEN

  def test_signup_pass_with_token
    user_count = User.count
    delete_some_user
    post_with_csrf_protection('/registro', email: some_email)
    assert_equal 200, last_response.status
    assert_equal user_count + 1, User.count
  end

  def test_answer_pass_with_token
    answer_count = Answer.count
    post_with_csrf_protection('/respuestas', selected: '1')
    assert_equal 200, last_response.status
    assert_equal answer_count + 1, Answer.count
  end

end

