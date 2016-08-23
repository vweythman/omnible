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

	# VALIDATIONS
	# ============================================================
	validates :name, presence: true, length: { maximum: 100 }

	# MODULES
	# ============================================================
	extend FriendlyId
	extend Organizable
	include Documentable
	include Editable

	# CALLBACKS
	# ============================================================
	before_validation :typify, on: [:update, :create]
	before_validation :update_tags,     on: [:update, :create]

	# SCOPES
	# ============================================================
	scope :order_by_generic, -> { includes(:generic).order('generics.name, items.name') }

	# ASSOCIATIONS
	# ============================================================
	# - Joins
	has_many :item_taggings, -> { Tagging.quality }, dependent: :destroy, class_name: "Tagging", as: :tagger
	has_many :possessions, dependent: :destroy

	# - General
	belongs_to :generic
	has_many   :characters,   through: :possessions
	has_many   :quality_tags, through: :item_taggings
	
	# CLASS METHODS
	# ============================================================
	# OrganizedAll - creates an list of all identities organized by facet
	def self.organized_all(list = Item.includes(:generic))
		self.organize(list)
	end

	# ATTRIBUTES
	# ============================================================
	friendly_id :name, :use => :slugged
	attr_accessor :visitor, :nature, :descriptions

	def nature
		@nature ||= "unspecified"
	end

	def descriptions
		@descriptions ||= nil
	end

	def visitor
		@visitor ||= nil
	end

	# PUBLIC METHODS
	# ============================================================
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

	def editable?(user)
		user.id == uploader_id
	end

	def qualities
		quality_tags
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def typify
		self.generic = Generic.where(name: @nature).first_or_create
	end

	def update_tags
		unless descriptions.nil?
			old_tags     = self.quality_tags
			current_tags = Tag.merged_tag_names(old_tags, descriptions, visitor)
			organize_tags(old_tags, current_tags)
		end
	end

	def organize_tags(old_tags, new_tags)
		old_tags.delete(old_tags - new_tags)
		old_tags <<    (new_tags - old_tags)
	end

end
