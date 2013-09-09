class User
  include MongoMapper::Document
  many :data_requests

  key :email, String, unique: true
  timestamps!

  validate :email_validation

  def email_validation
    # Taken from http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html
    if (email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/).nil?
      errors.add(:email, "no es correcto")
    end
  end

  def self.data_requests
    User.collection.aggregate([
      { "$unwind" => "$data_requests" },
      { "$project" => {
          "_id" => 0,
          "created_at" => 1,
          "category" => "$data_requests.category"
        }}
    ])
  end

  def self.data_requests_by_category
    User.collection.aggregate([
      { "$unwind" => "$data_requests" },
      { "$group" => {
          _id: "$data_requests.category",
          count: { "$sum" => 1 } } },
      { "$project" => { "category" => "$_id", "count" => 1, "_id" => 0 } }
    ])
  end

end

class DataRequest
  include MongoMapper::EmbeddedDocument

  key :description, String
  key :category,    String

  validate :at_least_one_field_is_present

  def to_s
    "[#{category}] #{description}"
  end

  def at_least_one_field_is_present
    if description.blank? && category.blank?
      errors.add(:description, "At least one field should be present")
    end
  end
end

