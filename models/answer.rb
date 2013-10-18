class Answer
  include MongoMapper::Document

  one :selected_option

  timestamps!

end

