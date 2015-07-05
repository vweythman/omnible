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

	# MODULES
	# ------------------------------------------------------------
	extend Organizable

	# SCOPES
	# ------------------------------------------------------------
	scope :main_characters, -> { where(role: 'main').joins(:character) }
	scope :side_characters, -> { where(role: 'side').joins(:character) }
	scope :mentioned_characters, -> { where(role: 'mentioned').joins(:character) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :character
	belongs_to :work

	# Type
	# - defines the type name if it exists
	def nature
		self.role
	end

	# Linkable
	# - grab what will be used when organizing
	def linkable
		self.character
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# Roles
	# - defines and collects the types of appearances
	def self.roles
		['main', 'side', 'mentioned']
	end

end
