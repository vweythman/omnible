# Generic
# ================================================================================
# generics belong to the type group, defining items
#
# ================================================================================

class Generic < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId     # slugged based on the name

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :items
	
end
