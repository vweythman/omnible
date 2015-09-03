# Description
# ================================================================================
# join table, tags characters with identities
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  anthology_id    | integer     | references anthology
#  work_id         | integer     | references work
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Description < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :within, ->(identity) {where("character_id IN (#{identity.descriptions.pluck(:character_id).join(",")})")}

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

end
