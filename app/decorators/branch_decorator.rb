class BranchDecorator < WorkDecorator

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

end
