# Membership
# ================================================================================
# join table, groups have characters
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  group_id        | integer     | references group
#  character_id    | integer     | references character
#  role            | string      | type column
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Membership < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :group
	belongs_to :character

	# CLASS METHODS
	# ------------------------------------------------------------
	# roles - defines and collects the types of memberships
	def self.roles
		['included', 'associated']
	end

end
