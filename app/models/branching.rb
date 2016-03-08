# Branching
# ================================================================================
# join table between branches
#
# Table Variables
# --------------------------------------------------------------------------------
#  variable       | type           | about
# --------------------------------------------------------------------------------
#  id             | integer        | unique
#  parent_node_id | interger       | references branch
#  child_node_id  | integer        | references branch
#  heading        | string         | link text
# ================================================================================

class Branching < ActiveRecord::Base

	# VALIDATIONS
	# ============================================================
	validates_uniqueness_of :child_node_id, :scope => :parent_node_id

	# ASSOCIATIONS
	# ============================================================
	belongs_to :parent_node, class_name: "Branch", inverse_of: :child_branchings
	belongs_to :child_node,  class_name: "Branch", inverse_of: :parent_branchings

	# NESTED ATTRIBUTION
	# ============================================================
	accepts_nested_attributes_for :child_node

	# PUBLIC METHODS
	# ============================================================
	def storify_child
		if child_node.story_id.nil?
			self.child_node.story_id = self.parent_node.story_id
			self.child_node.save
		end
	end

end
