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

	def manage_kit(can_graft)
		if self.editable?(h.current_user)
			h.content_tag :div, class: "manager-editor" do
				h.concat edit_bar
				h.concat generation_toolkit(can_graft)
			end
		end
	end

	def branching_form
		h.content_tag :div, id: "branching-form" do "" end
	end

	def generation_toolkit(can_graft = graftable?)
		h.content_tag :div, class: "toolkit generation" do
			h.concat h.link_to "New Branch", h.branch_bubble_path(self), class:"icon icon-leaf"
			h.concat h.link_to("Graft to Existing Branch", h.graft_branch_path(self), remote: true , class:"icon icon-leaf") if can_graft
		end
	end

	def graftable?
		(story_grafting_branches - self.child_nodes.length) > 0
	end

	def story_grafting_branches
		self.story.branches.count
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
