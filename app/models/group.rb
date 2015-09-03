# Group
# ================================================================================
# a type of subject
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  description     | text        | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  uploader_id     | integer     | references user
# ================================================================================

class Group < ActiveRecord::Base
	
	# MODULES
	# ------------------------------------------------------------
	include Documentable  # member of the subject group

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :memberships

	# models that belong this model
	has_many :characters, through: :memberships

end
