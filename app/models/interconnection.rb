# Interconnection
# ================================================================================
# membership is a join model between characters and their interconnection type
#
# ================================================================================

class Interconnection < ActiveRecord::Base

  # VALIDATIONS and SCOPES
  # ------------------------------------------------------------
  scope :character_interconnections, ->(person_id) { where("left_id = ? OR right_id = ?", person_id, person_id)}
  
  # ASSOCIATIONS
  # ------------------------------------------------------------
  belongs_to :left, class_name: "Character"
  belongs_to :relator
  belongs_to :right, class_name: "Character"

  delegate :right_heading, :left_heading, to: :relator

  # Flip
  # - determine the correct relator heading and character
  def flip(character)
  	if self.left.id == character.id
  		[self.right_heading, self.right]
  	else
  		[self.left_heading, self.left]
  	end
  end

  def self.organize(interconnections, character)
  	list = Hash.new
  	interconnections.map { |interconnection|
  		heading, linkable = interconnection.flip(character)
  		list[heading] = Array.new if list[heading].nil?
  		list[heading] << linkable
  	}
  	return list
  end

end
