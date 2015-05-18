# Appearance
# ================================================================================
# appearance is a join model for works and characters
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  self.roles                  | array       | defines and collects the types of 
#                              |             | appearances
# ================================================================================

class Appearance < ActiveRecord::Base

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character
	belongs_to :work

	# CLASS METHODS
	# ------------------------------------------------------------
	# roles
	# - defines and collects the types of appearances
	def self.roles
		['main', 'side', 'mentioned']
	end

end
