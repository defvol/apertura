class Answer
  include MongoMapper::Document

  one :selected_option
  key :user_id

  timestamps!

  def self.votes_by_category
    Answer.collection.aggregate([
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

  def self.daily
    Answer.collection.aggregate([
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

