# Description
# ================================================================================
# description is a join model for characters and identities
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  facet_id                    | integer     | finds the id of the identity's 
#                              |             | facet if it exists
# ================================================================================

class Description < ActiveRecord::Base

	# SCOPES
	# ------------------------------------------------------------
	scope :within, ->(identity) {where("character_id IN (#{identity.descriptions.pluck(:character_id).join(",")})")}

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# models that possess these models
	belongs_to :character
	belongs_to :identity

	# indirect associations and subgroups
	belongs_to :appearance, foreign_key: :character_id, primary_key: :character_id
	has_one :facet, through: :identity

	# METHODS
	# ------------------------------------------------------------
	# facetID
	# finds the id of the identity's facet if it exists
	def facet_id
		facet.id unless identity.nil?
	end

end
