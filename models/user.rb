class User
  include MongoMapper::Document

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

