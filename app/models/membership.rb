# Membership
# ================================================================================
# membership is a join model for characters and groups
#
# Methods (max length: 25 characters)
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  self.roles                  | array       | defines and collects the types of 
#                              |             | appearances
# ================================================================================

class Membership < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :group
	belongs_to :character

	# CLASS METHODS
	# ------------------------------------------------------------
	# roles
	# - defines and collects the types of memberships
	def self.roles
		['included', 'associated']
	end

end
