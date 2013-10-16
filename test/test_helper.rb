ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require_relative '../landa'

class Test::Unit::TestCase
  include Rack::Test::Methods

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
end

