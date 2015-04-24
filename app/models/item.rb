class Item < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	include Documentable  # member of the subject group
	include Taggable      # member of the tag group
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

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by facet
	def self.organized_all(list = Item.includes(:generic))
		self.organize(list)
	end

end
