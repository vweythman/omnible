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
	has_many :creatorships,   inverse_of: :category
	has_many :work_bylinings, foreign_key: "creator_id"

	# - Has
	has_many :users, through: :creatorships
	has_many :works, through: :creatorships

	# - Belongs to
	has_many :describers, through: :work_bylinings

	# ATTRIBUTES
	# ------------------------------------------------------------
	attr_accessor :work_types

	def work_types
		work_types ||= describers.pluck(:id)
	end

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def heading
		self.name
	end

	def agentive_title
		agentive.titleize
	end

	def connected? type
		describers.include? type
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def agentize
		unless work_types.nil?
			types  = WorksTypeDescriber.among(@work_types)

			describers.delete(describers - types)
			describers << (types - describers)
		end
	end

end
