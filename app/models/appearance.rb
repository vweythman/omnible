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

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :character_id, presence: true
	validates :work_id,      presence: true
	validates_uniqueness_of :character_id, :scope => :work_id

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
