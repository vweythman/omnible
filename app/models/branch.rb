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
	has_many :parent_branchings, class_name: "Branching", foreign_key: "child_node_id",  dependent: :destroy
	has_many :child_branchings,  class_name: "Branching", foreign_key: "parent_node_id", dependent: :destroy

	# BELONGS TO
	# ------------------------------------------------------------
	belongs_to :story, class_name: "Work"
	has_many   :parent_nodes, through: :parent_branchings

	# HAS
	# ------------------------------------------------------------
	has_many :child_nodes, through: :child_branchings
	has_one  :story_root,  foreign_key: "trunk_id"

	# PUBLIC METHODS
	# ============================================================
	def bubble(heading)
		b = Branching.new
		b.root(heading, self)
		b.child_node
	end

	def graft(heading, branch)
		unless child_nodes.include? branch
			b = Branching.new
			b.root(heading, self, branch)
		end
	end

	def plant(heading, branch)
		unless parent_nodes.include? branch
			b = Branching.new
			b.root(heading, branch, self)
		end
	end

end
