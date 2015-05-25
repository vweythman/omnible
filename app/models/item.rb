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
	include Documentable  # member of the subject group
	extend Taggable      # member of the tag group
	extend Organizable    # has a type
	extend FriendlyId     # slugged based on the name
	
	# NONTABLE VARIABLES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# joins
	has_many :item_descriptions

	# models that belong to this model
	belongs_to :generic
	has_many :qualities, :through => :item_descriptions
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :item_descriptions, :allow_destroy => true

	# METHODS
	# ------------------------------------------------------------
	# Heading
	# - defines the main means of addressing the model
	def heading
		name
	end

	# Type
	# - defines the type name if it exists
	def type
		generic.name unless generic.nil?
	end

	# ReorganizeTags
	# - reassess current tag and return ids
	def update_tags(list)
		ItemDescription.not_among(self.id, list).destroy_all
		ItemDescription.are_among(self.id, list).pluck(:quality_id)
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by facet
	def self.organized_all(list = Item.includes(:generic))
		self.organize(list)
	end

end
