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
    @user = User.new(email: some_email, data_requests:@requests)
    @user.save
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
        }
      ]
    assert_equal response.to_json, last_response.body
  end

  def test_it_returns_data_requests_by_category
    save_some_requests
    get '/categories.json'
    response = [
      {
        count: 1,
        category: @requests[2][:category]
      },
      {
        count: 2,
        category: @requests[0][:category]
      }
    ]
    assert_equal response.to_json, last_response.body
  end

end

