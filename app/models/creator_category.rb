# CreatorCategory
# ================================================================================
# is what it says it is
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | unique
#  agentive        | string      | default: 'by'
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================
class CreatorCategory < ActiveRecord::Base

	# - Joins
	has_many :creatorships, inverse_of: :category

	# - Has
	has_many :users, through: :creatorships
	has_many :works, through: :creatorships

	# - Belongs to
	has_and_belongs_to_many :works_type_describers, inverse_of: :creator_categories

end
