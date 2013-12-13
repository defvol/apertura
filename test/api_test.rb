require_relative './test_helper'

class ApiTest < Test::Unit::TestCase

  def app
    Sinatra::Application
  end

  def setup
    set_some_poll_options
    Answer.delete_all
    save_some_answers

    # Timeframe
    @from = '2013-10-23T00:00:00-06:00'
    @to = '2013-11-16T23:59:59-05:00'
    @from_date = Time.new(2013, 10, 23, 00, 00, 00, "-06:00")
    @to_date = Time.new(2013, 11, 16, 23, 59, 59, "-05:00")
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

  def test_it_returns_votes_by_category
    get '/votes.json'
    assert_response_equals([
      {
        count: 5,
        category: "Lorem ipsum"
      }
    ])
  end

  def test_it_returns_votes_by_category_in_time_range
    create_answer_at_date(@from_date + 1.day)
    get "/votes.json?from=#{@from}&to=#{@to}"
    assert_response_equals([
      {
        count: 1,
        category: "Lorem ipsum"
      }
    ])
  end

  def test_it_returns_dataset_results
    get '/answers/datasets.json'
    assert_response_equals([
      {
        count: 2,
        dataset: Option.where(pseudo_uid: 100).all.first.text
      },
      {
        count: 3,
        dataset: Option.where(pseudo_uid: 101).all.first.text
      }
    ])
  end

  def test_it_returns_votes_per_day
    create_answer_at_date(Time.now - 1.day)
    get '/answers/daily.json'
    assert_response_equals([
      {
        count: 1,
        date: (Time.now.utc - 1.day).strftime("%Y-%m-%d")
      },
      {
        count: 5,
        date: Time.now.utc.strftime("%Y-%m-%d")
      }
    ])
  end

  def test_it_returns_daily_votes_in_time_range
    # Mocks with fixed creation date
    [
      Time.new(2013, 10, 22, 00, 00, 00, "-06:00"),
      @from_date,
      @to_date - 1.day,
      Time.new(2013, 11, 17, 23, 59, 59, "-05:00")
    ].each { |d| create_answer_at_date(d) }

    get "/answers/daily.json?from=#{@from}&to=#{@to}"
    assert_response_equals([
      {
        count: 1,
        date: @from_date.strftime("%Y-%m-%d")
      },
      {
        count: 1,
        date: @to_date.strftime("%Y-%m-%d")
      }
    ])
  end

  def test_it_returns_dump_of_chosen_categories
    now = Time.now.utc
    Answer.all.each do |a|
      a.created_at = now
      a.save
    end

    before_date = now - 1.day
    create_answer_at_date(before_date)

    get '/answers/categories_dump.json'
    assert_response_equals([
      { fecha: before_date, respuesta: "Lorem ipsum" },
      { fecha: now, respuesta: "Lorem ipsum" },
      { fecha: now, respuesta: "Lorem ipsum" },
      { fecha: now, respuesta: "Lorem ipsum" },
      { fecha: now, respuesta: "Lorem ipsum" },
      { fecha: now, respuesta: "Lorem ipsum" }
    ])
  end

end

