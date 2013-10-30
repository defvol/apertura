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
    count = User.count
    post_with_csrf_protection '/registro'
    assert_equal count, User.count
  end

  def test_email_uniqueness
    delete_some_user
    count = User.count
    2.times { post_with_csrf_protection '/registro', { :email => some_email } }
    assert_equal count + 1, User.count
  end

  def test_email_validation
    count = User.count
    post_with_csrf_protection '/registro', { email: 'bar' }
    assert_equal count, User.count
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
    post_with_csrf_protection '/respuestas', selected: '1'
    assert_equal count_before + 1, Answer.count
    assert_equal @@csrf_token, Answer.last.user_id
  end

  def test_it_validates_existence_of_selected_option
    selected = SelectedOption.new(pseudo_uid: 31337, parent_uid: 1, text: 'Foo')
    selected.save
    assert_equal 1, selected.errors.count
    assert_equal "Pseudo uid no existente", selected.errors.full_messages.last
  end

end

