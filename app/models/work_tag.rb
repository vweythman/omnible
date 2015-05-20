class WorkTag < ActiveRecord::Base

	# MODULES
	# ------------------------------------------------------------
	extend Organizable # has a type

	# SCOPES
	# ------------------------------------------------------------
	scope :concepts, -> { where(tag_type: 'Concept').joins('LEFT OUTER JOIN concepts ON work_tags.tag_id = concepts.id')}

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
