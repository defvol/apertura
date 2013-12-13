ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require_relative '../landa'

class Test::Unit::TestCase
  include Rack::Test::Methods

  @@csrf_token = 'fubar'

  def some_email
    "test@foo.bar"
  end

  def delete_some_user
    delete_user_with_email(some_user.email)
  end

  def some_user
    User.find_or_create_by_email(some_email)
  end

  def delete_user_with_email(email)
    user = User.find_by_email(email)
    user.delete if user
  end

  def signup_with_email(email)
    fill_in('email', :with => email)
    click_button('signup-submit')
  end

  def signup
    signup_with_email(some_email)
  end

  # Hijacks Javascript functions
  def stub_js_function(function_name, return_value)
    page.execute_script <<-JAVASCRIPT
        #{function_name} = function() { return '#{return_value}' };
    JAVASCRIPT
  end

  def set_some_poll_options
    Option.delete_all
    Option.create(pseudo_uid: 1, text: "Lorem ipsum")
    Option.create(pseudo_uid: 100, parent_uid: 1, text: "Echo Park kitsch readymade")
    Option.create(pseudo_uid: 101, parent_uid: 1, text: "Lo-fi post-ironic et")
    Option.all
  end

  def post_with_csrf_protection(path, options = {})
    params = { 'authenticity_token' => @@csrf_token }.merge(options)
    post(path, params, 'rack.session' => { :csrf => params['authenticity_token'] })
  end

  def select_option(id)
    option = Option.where(pseudo_uid: id).all.first
    SelectedOption.new(JSON.parse(option.to_json)).to_json
  end

  def save_some_answers
    5.times { Answer.create(selected_option: JSON.parse(select_option(1))) }
    2.times { Answer.create(selected_option: JSON.parse(select_option(100))) }
    3.times { Answer.create(selected_option: JSON.parse(select_option(101))) }
  end

  def assert_response_equals(response)
    assert_equal response.to_json, last_response.body
  end

  def create_answer_at_date(date)
    a = Answer.create(selected_option: JSON.parse(select_option(1)))
    a.created_at = date
    a.save
  end

end

