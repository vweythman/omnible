# Creatorship
# ================================================================================
# join table
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable            | type           | about
# --------------------------------------------------------------------------------
#  id                  | integer        | unique
#  work_id             | interger       | references work
#  creator_id          | integer        | references character
#  creator_category_id | integer        | references character
#  created_at          | datetime       | must be earlier or equal to updated_at
#  updated_at          | datetime       | must be later or equal to created_at
# ================================================================================

class Creatorship < ActiveRecord::Base

	# CALLBACKS
	# ============================================================
	before_validation :set_default, on: [:update, :create]

	# SCOPES
	# ============================================================
	scope :are_among_for, ->(cids) { where("creator_id IN (?)", cids)}

	# ASSOCIATIONS
	# ============================================================
	belongs_to :category, class_name: "CreatorCategory", inverse_of: :creatorships, foreign_key: "creator_category_id"
	belongs_to :creator,  class_name: "Character"
	belongs_to :work

	belongs_to :pseudonyming, foreign_key: "creator_id", primary_key: "character_id"
	has_one    :user,         through: :pseudonyming

	# PRIVATE METHODS
	# ============================================================
	# ============================================================
	private
	def set_default
		self.category ||= CreatorCategory.where(name: "creator", agentive: "created by").first_or_create
	end

end
