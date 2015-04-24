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
#  slug         | string         | maximum of 250 characters, based on name
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# --------------------------------------------------------------------------------
# 
# Model Associations
# --------------------------------------------------------------------------------
#  models that reference concepts         : works
#
# Methods
# --------------------------------------------------------------------------------
#  name (max: 25 characters)   | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
# ================================================================================

class Concept < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Imaginable    # member of the idea group
	include Taggable      # member of the tag group
	extend FriendlyId     # slugged based on the name
	
	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, presence: true
	
	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :conceptions

	# models that reference concepts
	has_many :works, :through => :conceptions

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

end
