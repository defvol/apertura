require_relative './test_helper'

class StressTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def test_it_throttles_answers
    answer_count = Answer.count

    10.times { post_with_csrf_protection('/respuestas', selected: '1') }
    assert_equal 429, last_response.status

    assert_not_equal answer_count + 10, Answer.count
  end

  def test_it_bans_signup_scrapers
    User.delete_all
    user_count = User.count

    @some_session = ('a'..'z').to_a.sample(5).join
    4.times do |i|
      post_with_csrf_protection('/registro', {
        email: "#{i}_#{some_email}",
        authenticity_token: @some_session })
      sleep 1.1
    end

    post_with_csrf_protection('/registro', {
      email: "31337_#{some_email}",
      authenticity_token: @some_session })

    assert_equal 403, last_response.status
    assert_equal user_count, User.count
  end

end

