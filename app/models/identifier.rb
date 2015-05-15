class Identifier < ActiveRecord::Base

  scope :not_among, ->(character_id, identifiers) { where("character_id = ? AND name NOT IN (?)", character_id, identifiers)}
  scope :are_among, ->(character_id, identifiers) { where("character_id = ? AND name IN (?)", character_id, identifiers)}

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :character
  
  # METHODS
  # ------------------------------------------------------------
  # Heading
  # - defines the main means of addressing the model
  def heading 
  	name
  end

end
