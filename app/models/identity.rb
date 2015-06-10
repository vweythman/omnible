# Identity
# ================================================================================
# identities belong to the idea group of tags
#
# Variables
# --------------------------------------------------------------------------------
#  variable     | type           | about
# --------------------------------------------------------------------------------
#  id           | integer        | unique
#  name         | string         | maximum of 250 characters
#  slug         | string         | maximum of 250 characters, based on name
#  created_at   | datetime       | must be earlier or equal to updated_at
#  updated_at   | datetime       | must be later or equal to created_at
# --------------------------------------------------------------------------------
#
# Methods
# --------------------------------------------------------------------------------
#  name (max: 25 characters)   | output type | description
# --------------------------------------------------------------------------------
#  heading                     | string      | defines the main means of
#                              |             | addressing the model
#  type                        | string      | returns the facet name when it
#                              |             | exists
#  typify                      | object      | set the facet type of the identity
# ================================================================================
class Identity < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend Taggable      # member of the tag group
	extend Organizable    # has a type

	# SCOPES
	# ------------------------------------------------------------
	scope :alphabetic, -> { order('lower(name)') }
	scope :ages,    -> { where(facet: 'age') }
	scope :genders, -> { where(facet: 'gender') }
	scope :next_in_facet, ->(identity) { where('facet_id = ? AND name > ?', identity.facet_id, identity.name).order('name ASC') }
	scope :prev_in_facet, ->(identity) { where('facet_id = ? AND name < ?', identity.facet_id, identity.name).order('name DESC') }

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
	# - returns the facet name when it exists
	def type
		facet.name unless facet.nil?
	end

	# Typify
	# - set the facet type of the identity
	def typify(name)
		self.facet = Facet.where(name: name).first_or_create
	end

	def faceted_next
		@faceted_next.nil? ? @faceted_next = Identity.next_in_facet(self).first : @faceted_next
	end

	def faceted_prev
		@faceted_prev.nil? ? @faceted_prev = Identity.prev_in_facet(self).first : @faceted_prev
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by facet
	def self.organized_all(list = Identity.includes(:facet).alphabetic)
		Identity.organize(list)
	end

end
