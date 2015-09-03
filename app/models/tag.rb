# Tag
# ================================================================================
# tags are used for works
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  name         | string         | maximum of 250 characters
#  slug         | string         | maximum of 250 characters, based on name
#  created_at   | datetime       | <= updated_at
#  updated_at   | datetime       | >= created_at
# ================================================================================

class Tag < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, presence: true
	
	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId
	include Taggable
	
	# SCOPES
	# ------------------------------------------------------------
	scope :not_among, ->(tags) { where("name NOT IN (?)", tags) }
	scope :are_among, ->(tags) { where("name IN (?)", tags) }

	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :taggings

	# models that reference tags
	has_many :works, :through => :taggings

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

end
