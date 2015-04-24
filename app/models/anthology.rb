# Anthology
# ================================================================================
# anthologies to the collection group
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
# ================================================================================

class Anthology < ActiveRecord::Base
	
	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true

	# ASSOCIATIONS
	# ------------------------------------------------------------
	has_many :collections
	has_many :works, :through => :collections
	# -- ownership // user

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :collections

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

end
