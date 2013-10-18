# Damn it: Anti-DRY pattern
# This is a duplicated embeddable version of the Option collection

class SelectedOption
  include MongoMapper::EmbeddedDocument

  key :pseudo_uid, Integer
  key :parent_uid, Integer
  key :text, String

  validate :existence

  def existence
    if Option.where(pseudo_uid: pseudo_uid).all.empty?
      errors.add(:pseudo_uid, "no existente")
    end
  end
end

