require_relative './test_helper'

class ApiTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def save_some_requests
    delete_some_user
    @requests = [
      { category: "Ed" },
      { category: "Ed" },
      { category: "Health" }
    ]
    @user = User.create(email: some_email, data_requests:@requests)

    early_email = some_email.insert(0, "early-")
    @early_adopter = User.find_by_email(early_email)
    @early_adopter.delete if @early_adopter
    @early_adopter = User.create(email: early_email, data_requests:[@requests[2]])
    @early_adopter.created_at = @early_adopter.created_at - 60 * 60 * 24
    @early_adopter.save
  end

  def save_some_answers
    option = Option.where(pseudo_uid: 1).all.first
    selected = SelectedOption.new(JSON.parse(option.to_json))
    5.times { Answer.create(selected_option: JSON.parse(selected.to_json)) }
  end

  def test_requests_json
    save_some_requests
    get '/requests.json'
    response =
      [
        {
          created_at: @user.created_at,
          category: @requests[0][:category]
        },
        {
          created_at: @user.created_at,
          category: @requests[1][:category]
        },
        {
          created_at: @user.created_at,
          category: @requests[2][:category]
        },
        {
          created_at: @early_adopter.created_at,
          category: @requests[2][:category]
        }
      ]
    assert_equal response.to_json, last_response.body
  end

  def test_it_returns_data_requests_by_category
    save_some_requests
    get '/categories.json'
    response = [
      {
        count: 2,
        category: @requests[2][:category]
      },
      {
        count: 2,
        category: @requests[0][:category]
      }
    ]
    assert_equal response.to_json, last_response.body
  end

  def test_it_returns_data_requests_by_category_and_day_of_year
    save_some_requests
    get '/daily.json'
    response = [
      {
        count: 2,
        category: @requests[0][:category],
        day: @user.created_at.yday
      },
      {
        count: 1,
        category: @requests[2][:category],
        day: @early_adopter.created_at.yday
      },
      {
        count: 1,
        category: @requests[2][:category],
        day: @user.created_at.yday
      }
    ]
    assert_equal response.to_json, last_response.body
  end

  def test_it_gets_first_options
    set_some_poll_options
    get '/options.json'
    assert_equal Option.where(:parent_uid.exists => false).all.to_json, last_response.body
  end

  def test_it_gets_options_for_a_parent_uid
    set_some_poll_options
    get '/options/1.json'
    assert_equal Option.where(parent_uid: 1).all.to_json, last_response.body
  end

  def test_it_returns_data_requests_by_category
    set_some_poll_options
    Answer.delete_all
    save_some_answers

    get '/votes.json'
    response = [
      {
        count: 5,
        category: "Lorem ipsum"
      }
    ]
    assert_equal response.to_json, last_response.body
  end

end

