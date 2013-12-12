class Answer
  include MongoMapper::Document

  one :selected_option
  key :user_id

  timestamps!

  # A scope replica
  # Receives date-strings and setups query parameters
  def self.between_dates(low, high)
    begin
      from = Time.parse(low)
      to = Time.parse(high)
    rescue ArgumentError, TypeError
      from ||= Time.new(0)
      to ||= Time.now
    end

    { "$match" => {
      "created_at" => {
        "$gte" => from,
        "$lte" => to } } }
  end

  def self.votes_by_category(from, to)
    Answer.collection.aggregate([
      between_dates(from, to),
      { "$match" => { "selected_option.parent_uid" => { "$exists" => false } } },
      { "$group" => {
          _id: "$selected_option.text",
          count: { "$sum" => 1 } } },
      { "$project" => {
          "category" => "$_id",
          "count" => 1,
          "_id" => 0 } }
    ])
  end

  def self.datasets
    Answer.collection.aggregate([
      { "$match" => { "selected_option.parent_uid" => { "$exists" => true } } },
      { "$group" => {
          _id: "$selected_option.text",
          count: { "$sum" => 1 } } },
      { "$project" => {
          "dataset" => "$_id",
          "count" => 1,
          "_id" => 0 } }
    ])
  end

  def self.daily(from, to)
    Answer.collection.aggregate([
      between_dates(from, to),
      { "$match" => { "selected_option.parent_uid" => { "$exists" => false } } },
      { "$group" => {
        _id: {
          year:   { "$year" => "$created_at" },
          month:  { "$month" => "$created_at" },
          day:    { "$dayOfMonth" => "$created_at" } },
        dt_sample: { "$first" => "$created_at" },
        count: { "$sum" => 1 } } },
      { "$sort" => { dt_sample: 1 } },
      { "$project" => {
        "date" => { "$substr" => ["$dt_sample", 0, 10] },
        "count" => 1,
        "_id" => 0 } }
    ])
  end

  def self.entries
    Answer.collection.aggregate([
      { "$match" => { "selected_option.parent_uid" => { "$exists" => false } } },
      { "$sort" => { created_at: 1 } },
      { "$project" => {
        "fecha" => "$created_at",
        "respuesta" => "$selected_option.text",
        "_id" => 0 } }
    ])
  end

end

