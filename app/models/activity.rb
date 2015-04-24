# Activity
# ================================================================================
# activities belong to the idea group of tags
#
# Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  name         | string         | maximum of 250 characters
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# --------------------------------------------------------------------------------
# 
# Methods
# --------------------------------------------------------------------------------
#  name (max: 25 characters)   | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
# ================================================================================

class Activity < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Imaginable    # member of the idea group
	include Taggable      # member of the tag group
	extend FriendlyId     # slugged based on the name
	
	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true
	
	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

end
