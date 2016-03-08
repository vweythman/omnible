class BranchingDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	def klass
		:branching
	end

	def quoted_heading
		h.content_tag :b do "\"#{self.heading}\"" end
	end

	def go_to
		lbl =  h.content_tag :b do "Goes To: " end
		lnk = h.link_to self.child_node.title, [self.child_node.story, self.child_node]
		(lbl + lnk).html_safe
	end

	def grafting_options(parent)
		options        = parent.graftable_branches + [[self.child_node.title, self.child_node.id]]
		titled_options = options.map {|b| 
			b[0] = "Branch: " + b[0]
			b
		}
		h.options_for_select(titled_options, self.child_node.id)
	end

end
