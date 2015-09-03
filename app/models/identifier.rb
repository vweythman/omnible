# Identifier
# ================================================================================
# subtype for characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  character_id    | integer     | references character
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Identifier < ActiveRecord::Base

  # SCOPES 
  # ------------------------------------------------------------
  scope :not_among_for, ->(character_id, identifiers) { where("character_id = ? AND name NOT IN (?)", character_id, identifiers)}
  scope :are_among_for, ->(character_id, identifiers) { where("character_id = ? AND name IN (?)", character_id, identifiers)}

  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :character

  # PUBLIC METHODS
  # ------------------------------------------------------------
  # Heading - defines the main means of addressing the model
  def heading 
    name
  end

end
