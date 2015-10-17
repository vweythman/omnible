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

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.update_for(model, list)
		if list.length > 0
			Identifier.transaction do
				remove  = Identifier.not_among_for(model.id, list).destroy_all
				current = Identifier.are_among_for(model.id, list).pluck(:name)

				to_be_added = list - current

				to_be_added.each do |name|
					Identifier.where(character_id: model.id, name: name).first_or_create
				end
			end
		else
			model.identifiers.destroy_all
		end
	end

end
