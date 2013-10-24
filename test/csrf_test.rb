require_relative './test_helper'

class CsrfTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def test_signup_fails_without_token
    delete_some_user
    user_count = User.count
    post('/registro', { :email => some_email })
    assert_not_equal last_response.status, 200
    assert_equal user_count, User.count
  end

  def test_answer_fails_without_token
    answer_count = Answer.count
    post('/respuestas', { selected: '1' })
    assert_not_equal last_response.status, 200
    assert_equal answer_count, Answer.count
  end

  def test_signup_pass_with_token
    user_count = User.count
    delete_some_user
    post_with_csrf_protection('/registro', email: some_email)
    assert_equal last_response.status, 200
    assert_equal user_count + 1, User.count
  end

  def test_answer_pass_with_token
    answer_count = Answer.count
    post_with_csrf_protection('/respuestas', selected: '1')
    assert_equal last_response.status, 200
    assert_equal answer_count + 1, Answer.count
  end

end

