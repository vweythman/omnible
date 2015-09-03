# Friendship
# ================================================================================
# user interaction, join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  friender_id  | interger       | references user
#  friendee_id  | integer        | references user
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
#  is_mutual    | boolean        | 
# ================================================================================

class Friendship < ActiveRecord::Base
	
	# SCOPES
	# ------------------------------------------------------------
	scope :mutual,     ->{ where(is_mutual: 't') }
	scope :unrequited, ->{ where(is_mutual: 'f') }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :friender, class_name: "User"
	belongs_to :friendee, class_name: "User"

end
