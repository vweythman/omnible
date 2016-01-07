# Activity
# ================================================================================
# tags for events
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type        | about
# --------------------------------------------------------------------------------
#  id           | integer     | unique
#  name         | string      | maximum of 250 characters
#  created_at   | datetime    | must be earlier or equal to updated_at
#  updated_at   | datetime    | must be later or equal to created_at
# ================================================================================

class Activity < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true

	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId
	include Taggable

	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(activities) { where("name NOT IN (?)", activities) }
	scope :are_among, ->(activities) { where("name IN (?)", activities) }

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		name
	end

	def editable? user
		user.site_owner?
	end

end
