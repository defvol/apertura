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

    option = Option.where(pseudo_uid: 100).all.first
    selected = SelectedOption.new(JSON.parse(option.to_json))
    Answer.create(selected_option: JSON.parse(selected.to_json))
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

