# Character
# ================================================================================
# characters belong to the subject group of tags
#
# Variables (max length: 15 characters) 
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  about           | text        | can be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#
# Model Associations
# --------------------------------------------------------------------------------
# owned by  : work, groups
# has this  : identifiers, identities, viewpoints
#
# Methods (max length: 25 characters) 
# --------------------------------------------------------------------------------
#  method name                 | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
#  connections                 | array       | merges both left and right 
#                              |             | connections
# ================================================================================

class Character < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable  # member of the subject group
	include Taggable      # member of the tag group

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	validates :name, presence: true
	scope :top_appearers, -> {joins(:appearances).group("characters.id").order("COUNT(appearances.character_id) DESC").limit(10) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :appearances
	has_many :memberships
	has_many :descriptions
	has_many :possessions

	# models that possess these models
	has_many :groups, through: :memberships
	has_many :works,  through: :appearances

	# models that belong to this model
	has_many :identifiers
	has_many :identities, through: :descriptions
	has_many :items,      through: :possessions
	has_many :viewpoints 

	# indirect associations and subgroups
	has_many :opinions,   -> { where(recip_type: 'Character') } 
	has_many :prejudices, -> { where(recip_type: 'Identity')  }
	has_many :left_connections,  class_name: "Connection", foreign_key: "left_id"
	has_many :right_connections, class_name: "Connection", foreign_key: "right_id"

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :descriptions, :allow_destroy => true
	accepts_nested_attributes_for :identifiers,  :allow_destroy => true
	accepts_nested_attributes_for :opinions,     :allow_destroy => true
	accepts_nested_attributes_for :possessions,  :allow_destroy => true
	accepts_nested_attributes_for :prejudices,   :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

	# Connections
	# - merges both left and right connections
	def connections
		Connection.character_connections(self.id).order(:relator_id).includes(:relator)
	end

end
