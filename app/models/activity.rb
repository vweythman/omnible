# Activity
# ================================================================================
# activities are a type of tag which describe actions that can be undertaken
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
	extend Taggable   # methods for general tags
	extend FriendlyId # methods for clean urls

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(activities) { where("name NOT IN (?)", activities) }
	scope :are_among, ->(activities) { where("name IN (?)", activities) }

	# VALIDATIONS
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
