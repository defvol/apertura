require_relative './test_helper'

require 'capybara'
require 'capybara/dsl'

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL
  # Capybara.default_driver = :selenium

  def setup
    Capybara.app = Sinatra::Application.new
  end

=begin
  # PENDING: url changed!
  def test_it_can_add_new_fields
    Capybara.current_driver = :selenium
    visit '/'
    click_link 'new-data-request'
    assert_equal 2, all('.data-request').count
    Capybara.use_default_driver
  end

  def test_it_can_suggest_category
    Capybara.current_driver = :selenium

    delete_some_user
    visit '/'

    new_category = "Fooness"
    # Hijack Javascript prompt
    stub_js_function('window.prompt', new_category);
    select('Otro', :from => 'data-requests[][category]')

    signup

    assert_equal "[#{new_category}] #{}", some_user.data_requests.map(&:to_s).join(",")
    Capybara.use_default_driver
  end

  def test_it_signups
    delete_some_user

    visit '/'
    signup

    assert_equal '/signup', current_path
    assert_equal 1, User.where(email: some_email).count
  end

  def test_it_appends_requested_data
    delete_some_user

    description = 'Gasto en medicinas 2012'
    category = 'Salud'

    visit '/'
    fill_in('data-requests[][description]', :with => description)
    select(category, :from => 'data-requests[][category]')
    signup

    assert_equal "[#{category}] #{description}", some_user.data_requests.map(&:to_s).join(",")
  end

  def test_it_trims_empty_requests
    delete_some_user

    visit '/'
    signup

    assert_equal 0, some_user.data_requests.count
  end
=end

  def test_it_can_submit_answer_form_by_click
    set_some_poll_options
    count_before = Answer.count
    Capybara.current_driver = :selenium
    visit '/'
    click_link 'option-1'
    assert_equal '/answers', current_path
    assert_equal count_before + 1, Answer.count
    Capybara.use_default_driver
  end

  def test_it_shows_poll_results_when_poll_ends
    set_some_poll_options
    Capybara.current_driver = :selenium
    visit '/'
    click_link 'option-1'
    click_link 'option-100'
    assert_equal '/results', current_path
    Capybara.use_default_driver
  end

  def test_that_user_starts_over_when_poll_ends
    set_some_poll_options
    Capybara.current_driver = :selenium
    visit '/'
    click_link 'option-1'
    click_link 'option-100'
    click_link 'poll-reboot'
    assert_equal '/', current_path
    Capybara.use_default_driver
  end

end

