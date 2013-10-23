require_relative './test_helper'

require 'capybara'
require 'capybara/dsl'

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL
  Capybara.default_driver = :selenium

  def setup
    Capybara.app = Sinatra::Application.new
    I18n.locale = :es
  end

  def test_it_can_add_new_fields
    visit '/results'
    page.driver.browser.manage.window.resize_to(1000, 500)
    click_link 'new-data-request'
    assert_equal 2, all('.data-request').count
  end

=begin

  # This functionality was removed

  def test_it_can_suggest_category
    delete_some_user
    visit '/results'

    new_category = "Fooness"
    # Hijack Javascript prompt
    stub_js_function('window.prompt', new_category);
    select('Otro', :from => 'data-requests[][category]')

    signup

    assert_equal "[#{new_category}] #{}", some_user.data_requests.map(&:to_s).join(",")
  end

  def test_it_appends_requested_data
    delete_some_user

    description = 'Gasto en medicinas 2012'
    category = 'Salud'

    visit '/results'
    fill_in('data-requests[][description]', :with => description)
    select(category, :from => 'data-requests[][category]')
    signup

    assert_equal "[#{category}] #{description}", some_user.data_requests.map(&:to_s).join(",")
  end

=end

  def test_it_signups
    delete_some_user

    visit '/results'
    signup

    assert_equal '/signup', current_path
    assert_equal 1, User.where(email: some_email).count
    assert_equal true, page.has_text?(I18n.t('confirmation.thanks'))
  end

  def test_it_trims_empty_requests
    delete_some_user

    visit '/results'
    signup

    assert_equal 0, some_user.data_requests.count
  end

  def test_it_can_submit_answer_form_by_click
    set_some_poll_options
    count_before = Answer.count
    visit '/'
    click_link 'option-1'
    assert_equal '/answers', current_path
    assert_equal count_before + 1, Answer.count
  end

  def test_it_cycles_ad_infinitum
    visit '/'
    click_link 'option-1'
    click_link 'option-100'
    page.assert_selector('#option-1')
  end

  def test_that_user_may_finish_poll
    visit '/'
    click_link 'poll-finish'
    assert_equal '/results', current_path
  end

end

