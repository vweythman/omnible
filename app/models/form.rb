# Form
# ================================================================================
# categories for places
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

class Form < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true

	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId     # slugged based on the name

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :places
	
end
