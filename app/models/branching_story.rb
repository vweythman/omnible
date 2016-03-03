# BranchingStory
# ================================================================================
# type of narrative work
# see Work for table variables

class BranchingStory < Work

	# SCOPES
	# ============================================================
	scope :by_branches, -> { order("(SELECT COUNT(*) FROM branches WHERE story_id = works.id) DESC") }
	scope :by_average_branching, -> { order("(
		(
			SELECT COUNT(*) FROM branchings 
			INNER JOIN branches ON branchings.child_node_id = branches.id WHERE branches.story_id = works.id
		) / 1.0 * 
		MAX(
			1, (
				SELECT DISTINCT COUNT(DISTINCT branches.id) 
				FROM branches 
				INNER JOIN branchings ON branches.id = branchings.parent_node_id 
				INNER JOIN branches branches_parent_nodes_join ON branchings.child_node_id = branches_parent_nodes_join.id 
				WHERE branches_parent_nodes_join.story_id = works.id
			)
		)
	) DESC") }

	# ASSOCIATIONS
	# ============================================================
	# JOINS
	# ------------------------------------------------------------
	has_one :story_root, foreign_key: "story_id"

	# HAS
	# ------------------------------------------------------------
	has_many :branches, inverse_of: :story, foreign_key: "story_id"
	has_one  :trunk,    through:    :story_root

	has_many :parent_branchings, through: :branches
	has_many :child_branchings,  through: :branches

	has_many :parent_nodes, ->{uniq}, through: :parent_branchings
	has_many :child_nodes,  through: :child_branchings

	# CLASS METHODS
	# ============================================================
	def self.order_by(choice)
		case choice
		when "branches-count"
			by_branches
		when "average-branchings"
			by_average_branching
		else
			super(choice)
		end
	end

	# PUBLIC METHODS
	# ============================================================
	def average_branching
		@average_branching ||= 1.0 * self.parent_branchings.count / parentable_node_count
	end

	def parentable_node_count
		@parentable_node_count ||= [self.parent_nodes.count, 1].max
	end

end
