class Option
  include MongoMapper::Document

  key :pseudo_uid, Integer, unique: true
  key :parent_uid, Integer
  key :text, String, unique: true

end

