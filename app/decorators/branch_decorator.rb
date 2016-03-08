class BranchDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include CreativeContent::Composition
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	def graftable_branches
		@graftable_branches ||= self.story.branches.pluck(:title, :id) - self.child_nodes.pluck(:title, :id)
	end

	def graftable_options
		h.options_for_select(graftable_branches_with_label)
	end

	def graftable_branches_with_label
		@graftable_branches_with_label ||= graftable_branches.map {|b| 
			b[0] = "Branch: " + b[0]
			b
		}
	end

	def graftable?
		graftable_branches.length > 0
	end

	def index_rowspan
		!has_children? ? 3 : self.child_branchings.size + 2
	end

	def has_children?
		self.child_branchings.size > 0
	end

	def child_index_width
		@child_index_width ||= (editable? h.current_user) ? "trio" : "duo"
	end

end
