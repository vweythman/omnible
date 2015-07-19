# Item
# ================================================================================
# items are part of the subject group of tags
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
#  type                        | string      | defines the type name if it exists
#  update_tags                 | array       | reassess current tags and return 
#                              |             | ids
#  editable?                   | bool        | asks if work can be edited
#  self.sorter                 | string      | decide on the sort order
# ================================================================================

class Item < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable
	extend Organizable
	extend FriendlyId
	
	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :item_tags

	# - General
	belongs_to :generic
	has_many :qualities, :through => :item_tags
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :item_tags, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------

	# - defines the main means of addressing the model
	def heading
		name
	end

	# - defines the type name if it exists
	def nature
		generic.name unless generic.nil?
	end

	# - grab what will be used when organizing
	def linkable
		self
	end

	# - set the facet type of the identity
	def typify(name)
		self.generic = Generic.where(name: name).first_or_create
	end

	# - reassess current tag and return ids
	def update_tags(list)
		ItemTag.not_among_for(self.id, list).destroy_all
		ItemTag.are_among_for(self.id, list).pluck(:quality_id)
	end

	# CLASS METHODS
	# ------------------------------------------------------------

	# - creates an list of all identities organized by facet
	def self.organized_all(list = Item.includes(:generic))
		self.organize(list)
	end

end
