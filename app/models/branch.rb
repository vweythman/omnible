# BranchingStory
# ================================================================================
# subpart of branching stories
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable        | type        | about
# --------------------------------------------------------------------------------
#  id              | integer     | unique
#  title           | string      | maximum of 250 characters
#  content         | text        | cannot be null
#  story_id        | integer     | cannot be null
#  created_at      | datetime    | must be earlier or equal to updated_at
#  updated_at      | datetime    | must be later or equal to created_at
# ================================================================================

class Branch < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates :content, presence: true

	# ASSOCIATIONS
	# ============================================================
	# JOIN
	# ------------------------------------------------------------
	has_many :parent_branchings, class_name: "Branching", foreign_key: "child_node_id",  dependent: :destroy, inverse_of: :child_node
	has_many :child_branchings,  class_name: "Branching", foreign_key: "parent_node_id", dependent: :destroy, inverse_of: :parent_node

	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :story, class_name: "Work"
	has_many   :parent_nodes, through: :parent_branchings

	# HAS
	# ------------------------------------------------------------
	has_many :child_nodes, through: :child_branchings
	has_one  :story_root,  foreign_key: "trunk_id"

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :child_branchings

	# PUBLIC METHODS
	# ============================================================
	# ACTIONS
	# ------------------------------------------------------------
	def bubble(heading)
		branching            = Branching.new

		branching.heading    = heading
		branching.child_node = Branch.new

		self.child_branchings << branching
		return branching
	end

	def graft(heading, branch)
		if can_graft_to?(branch)
			branching            = Branching.new

			branching.heading    = heading
			branching.child_node = branch

			self.child_branchings << branching
			return branching
		end
	end

	def plant(heading, branch)
		unless parent_nodes.include? branch
			branching             = Branching.new

			branching.heading     = heading
			branching.parent_node = branch

			self.parent_branchings << branching
			return branching
		end
	end

	# QUESTIONS
	# ------------------------------------------------------------
	def can_graft_to?(branch)
		shares_story_with?(branch) && unlinked?(branch)
	end

	def shares_story_with?(branch)
		branch.story_id == self.story_id
	end

	def unlinked?(branch)
		!child_nodes.include?(branch)
	end

	def is_trunk?
		!story_root.nil?
	end

end
