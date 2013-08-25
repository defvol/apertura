class User
  include MongoMapper::Document
  many :data_requests

  key :email, String, unique: true
  timestamps!

  validate :email_validation

  def email_validation
    # Taken from http://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html
    if (email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/).nil?
      errors.add(:email, "is not valid")
    end
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

