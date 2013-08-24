class User
  include MongoMapper::Document

  key :email,        String
  timestamps!
end

