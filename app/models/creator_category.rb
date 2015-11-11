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
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================
class CreatorCategory < ActiveRecord::Base
	has_many :creatorships, inverse_of: :category
	has_many :users, through: :creatorships
	has_many :works, through: :creatorships
end
