# BranchingStory
# ================================================================================
# type of narrative work
# see Work for table variables

class BranchingStory < Work

	# HAS
	# ------------------------------------------------------------
	has_many :branches, :inverse_of => :story, foreign_key: "story_id"
	has_many :parent_branchings, through: :branches
	has_many :child_branchings,  through: :branches

	has_one :story_root, foreign_key: "story_id"

	has_one :trunk,         through: :story_root
	has_many :parent_nodes, through: :parent_branchings
	has_many :child_nodes,  through: :child_branchings

end
