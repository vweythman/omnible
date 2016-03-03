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

	# ASSOCIATIONS
	# ============================================================
	belongs_to :parent_node, class_name: "Branch"
	belongs_to :child_node, class_name: "Branch"

	# PUBLIC METHODS
	# ============================================================
	def root(h, pn, cn = Branch.new)
		self.heading     = h
		self.parent_node = pn
		self.child_node  = cn
	end

end
