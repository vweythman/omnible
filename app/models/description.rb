# Description
# ================================================================================
# join table, tags characters with identities
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  identity_id     | integer     | references identity
#  character_id    | integer     | references character
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Description < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :within, ->(identity) {where("character_id IN (#{identity.descriptions.pluck(:character_id).join(",")})")}
	scope :are_among_for, ->(character, ids) { where("character_id = ? AND identity_id IN (?)", character.id, ids)}
	scope :not_among_for, ->(character, ids) { where("character_id = ? AND identity_id NOT IN (?)", character.id, ids)}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Belongs to
	belongs_to :character
	belongs_to :identity

	# - References
	belongs_to :appearance, foreign_key: :character_id, primary_key: :character_id
	has_one    :facet,      through: :identity

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# facetID - finds the id of the facet if it exists
	def facet_id
		facet.id unless identity.nil?
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	def self.update_for(model, describers)
		ident = Identity.faceted_find_by(describers)
		list  = ident.map{ |i| i.id }

		if list.length > 0
			Description.transaction do
				remove  = Description.not_among_for(model, list).destroy_all
				current = Description.are_among_for(model, list).pluck(:identity_id)

				to_be_added = list - current

				to_be_added.each do |id|
					Description.where(character_id: model.id, identity_id: id).first_or_create
				end
			end
		else
			model.descriptions.destroy_all
		end
	end

end
