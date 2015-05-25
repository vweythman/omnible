class Identity < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Imaginable    # member of the idea group
	extend Taggable      # member of the tag group
	extend Organizable    # has a type

	# VALIDATIONS and SCOPES
	# ------------------------------------------------------------
	default_scope {order('facet_id, lower(name)')}
	scope :ages,    -> { where(facet: 'age') }
	scope :genders, -> { where(facet: 'gender') } 

	# ASSOCIATIONS
	# -----------------------------------------------------------
	# joins
	has_many :descriptions

	# model that possess identities
	has_many :characters, through: :descriptions
	belongs_to :facet, :inverse_of => :identities

	# indirect associations and subgroups
	has_many :appearances, source: :appearance, through: :descriptions
	has_many :works, ->{uniq}, source: :work, through: :appearances

	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :descriptions, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		"#{facet.name}: #{name}"
	end

	# Type
	# - finds the facet name when it exists
	def type
		facet.name unless facet.nil?
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by facet
	def self.organized_all(list = Identity.includes(:facet))
		Identity.organize(list)
	end

end
