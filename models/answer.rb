class Answer
  include MongoMapper::Document

  one :selected_option

  timestamps!

  def self.votes_by_category
    Answer.collection.aggregate([
      { "$group" => {
          _id: "$selected_option.text",
          count: { "$sum" => 1 } } },
      { "$project" => {
          "category" => "$_id",
          "count" => 1,
          "_id" => 0 } }
    ])
  end

end

