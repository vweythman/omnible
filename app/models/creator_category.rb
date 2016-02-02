# CreatorCategory
# ================================================================================
# is what it says it is
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  name            | string      | unique
#  agentive        | string      | default: 'by'
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================
class CreatorCategory < ActiveRecord::Base

	# VALIDATIONS
	# ------------------------------------------------------------
	validates :name, length: { maximum: 250 }, presence: true

	# CALLBACKS
	# ------------------------------------------------------------
	before_save :agentize

	# MODULES
	# ------------------------------------------------------------
	include EditableCategory

	# ASSOCIATIONS
	# ------------------------------------------------------------
	# - Joins
	has_many :creatorships, inverse_of: :category

	# - Has
	has_many :users, through: :creatorships
	has_many :works, through: :creatorships

	# - Belongs to
	has_and_belongs_to_many :works_type_describers, inverse_of: :creator_categories

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :work_types

	def work_types
		work_types ||= works_type_describers.pluck(:id)
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def heading
		self.name
	end

	def connected? type
		works_type_describers.include? type
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def agentize
		types  = WorksTypeDescriber.among(@work_types)

		works_type_describers.delete(works_type_describers - types)
		works_type_describers << (types - works_type_describers)
	end

end
