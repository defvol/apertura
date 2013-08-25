require_relative './test_helper'

require 'capybara'
require 'capybara/dsl'

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL
  # Capybara.default_driver = :selenium

  def setup
    Capybara.app = Sinatra::Application.new
  end

  def test_it_can_add_new_fields
    Capybara.current_driver = :selenium
    visit '/'
    click_link 'new-data-request'
    assert_equal 2, all('.data-request').count
    Capybara.use_default_driver
  end

  def test_it_signups
    delete_some_user

    visit '/'
    fill_in('email', :with => some_email)
    click_button('signup-submit')
    assert page.has_content?('Thanks')
  end

  def test_it_appends_requested_data
    delete_some_user

    description = 'Gasto en medicinas 2012'
    category = 'Salud'

    visit '/'
    fill_in('data-requests[][description]', :with => description)
    select(category, :from => 'data-requests[][category]')
    fill_in('email', :with => some_email)
    click_button('signup-submit')

    assert_equal "[#{category}] #{description}", some_user.data_requests.map(&:to_s).join(",")
  end

  def test_it_trims_empty_requests
    delete_some_user

    visit '/'
    fill_in('email', :with => some_email)
    click_button('signup-submit')

    assert_equal 0, some_user.data_requests.count
  end

end

