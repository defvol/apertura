require_relative './test_helper'

require 'capybara'
require 'capybara/dsl'
require 'rack_session_access/capybara'

class AcceptanceTest < Test::Unit::TestCase
  include Capybara::DSL
  Capybara.default_driver = :selenium

  def setup
    Capybara.app = Sinatra::Application.new
    I18n.locale = :es
    page.set_rack_session({ csrf: @@csrf_token })
  end

  def test_it_can_add_new_fields
    visit '/resultados'
    page.driver.browser.manage.window.resize_to(1000, 500)
    click_link 'new-data-request'
    assert_equal 2, all('.data-request').count
  end

  def test_it_signups
    delete_some_user

    visit '/resultados'
    signup

    assert_equal '/registro', current_path
    assert_equal 1, User.where(email: some_email).count
    assert_equal true, page.has_text?(I18n.t('confirmation.thanks'))
  end

  def test_it_trims_empty_requests
    delete_some_user

    visit '/resultados'
    signup

    assert_equal 0, some_user.data_requests.count
  end

  def test_it_can_submit_answer_form_by_click
    set_some_poll_options
    count_before = Answer.count
    visit '/'
    click_link 'option-1'
    assert_equal '/respuestas', current_path
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
    click_link 'option-1'
    click_link 'poll-finish'
    assert_equal '/resultados', current_path
  end

end

