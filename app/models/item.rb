# Item
# ================================================================================
# a type of subject
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable name   | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | maximum of 250 characters
#  generic_id      | integer     | references generic
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
#  slug            | string      | used for friendly url
#  uploader_id     | integer     | references user
#  publicity_level | integer     | default: 0
#  editor_level    | integer     | default: 0
# ================================================================================

class Item < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend FriendlyId
	extend Organizable
	include Documentable
	include Editable

	# CALLBACKS
	# ------------------------------------------------------------
	before_validation :typify, on: [:update, :create]
	before_save       :describe

	# SCOPES
	# ------------------------------------------------------------
	scope :order_by_generic, -> { includes(:generic).order('generics.name, items.name') }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :item_tags
	has_many :possessions

	# - General
	belongs_to :generic
	has_many :characters, through: :possessions
	has_many :qualities, :through => :item_tags
	
	# NESTED ATTRIBUTION
	# ------------------------------------------------------------
	accepts_nested_attributes_for :item_tags, :allow_destroy => true

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll - creates an list of all identities organized by facet
	def self.organized_all(list = Item.includes(:generic))
		self.organize(list)
	end

	# ATTRIBUTES
	# ------------------------------------------------------------
	friendly_id :name, :use => :slugged
	attr_accessor :nature, :descriptions

	def nature
		@nature ||= "unspecified"
	end

	def descriptions
		@descriptions ||= ""
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# Heading - defines the main means of addressing the model
	def heading
		name + " #{generic_heading}"
	end

	def generic_heading
		"(" + generic.name + ")" unless generic.nil?
	end

	# Nature - defines the type name if it exists
	def nature
		@nature ||= generic.nil? ? "" : generic.name
	end

	# Linkable - grab what will be used when organizing
	def linkable
		self
	end

	# UpdateTags - reassess current tag and return ids
	def update_tags(list)
		ItemTag.not_among_for(self.id, list).destroy_all
		ItemTag.are_among_for(self.id, list).pluck(:quality_id)
	end

	def editable?(user)
		user.id == uploader_id
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def typify
		self.generic = Generic.where(name: @nature).first_or_create
	end

	def describe
		nw_qualities = Quality.batch_by_name(@descriptions)

		self.qualities.delete(self.qualities - nw_qualities)
		self.qualities <<    (nw_qualities   - self.qualities)
	end

end
