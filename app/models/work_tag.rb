class WorkTag < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend Organizable # has a type

	# SCOPES
	# ------------------------------------------------------------
	scope :concepts,   -> { where(tag_type: 'Concept').joins('LEFT OUTER JOIN concepts ON work_tags.tag_id = concepts.id') }
	scope :activities, -> { where(tag_type: 'Activity').joins('LEFT OUTER JOIN activities ON work_tags.tag_id = activities.id') }
	scope :qualities,  -> { where(tag_type: 'Quality').joins('LEFT OUTER JOIN qualities ON work_tags.tag_id = qualities.id') }
	scope :not_among, ->(item_id, tag_type, tag_ids) { where("item_id = ? AND tag_type = ? AND tag_id NOT IN (?)", item_id, tag_type, tag_ids) }
	scope :are_among, ->(item_id, tag_type, tag_ids) { where("item_id = ? AND tag_type = ? AND tag_id IN (?)",     item_id, tag_type, tag_ids) }

	# ASSOCIATIONS
	# ------------------------------------------------------------
	belongs_to :work
	belongs_to :tag, :polymorphic => true

	# METHODS
	# ------------------------------------------------------------
	# Type
	# - defines the type name if it exists
	def type
		self.tag_type
	end

	# CLASS METHODS
	# ------------------------------------------------------------
	# OrganizedAll
	# - creates an list of all identities organized by tag_type
	def self.organized_all(list = WorkTag.include(:tag))
		self.organize(list)
	end

end
