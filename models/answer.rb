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

end

