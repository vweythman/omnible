# Pitch
# ================================================================================
# work prompt
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  about           | string      | can be null
#  user_id         | integer     | references user
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Pitch < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :user
	has_many :respondence, as: :caller
	has_many :responses,   through: :respondences

end
