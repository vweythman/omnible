# Interconnection
# ================================================================================
# join table, relationships between characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  left_id      | integer        | references character
#  relator_id   | integer        | references relator
#  right_id     | integer        | references character
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# ================================================================================

class Interconnection < ActiveRecord::Base

  # VALIDATIONS
  # ------------------------------------------------------------
  scope :character_interconnections, ->(person_id) { where("left_id = ? OR right_id = ?", person_id, person_id)}
  
  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :left, class_name: "Character"
  belongs_to :relator
  belongs_to :right, class_name: "Character"

  # DELEGATED METHODS
  # ------------------------------------------------------------
  delegate :right_heading, :left_heading, to: :relator

  # CLASS METHODS
  # ------------------------------------------------------------
  # Organize - sort and group similar interconnections
  def self.organize(interconnections, character)
    list = Hash.new
    interconnections.map { |interconnection|
      heading, linkable = interconnection.flip(character)
      list[heading] = Array.new if list[heading].nil?
      list[heading] << linkable
    }
    return list
  end

  # PUBLIC METHODS
  # ------------------------------------------------------------
  # Flip - determine the correct relator heading and character
  def flip(character)
  	if self.left.id == character.id
  		[self.right_heading, self.right]
  	else
  		[self.left_heading, self.left]
  	end
  end

end
