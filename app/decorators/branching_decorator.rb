class BranchingDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include InlineEditing

	# PUBLIC METHODS
	# ============================================================
	def klass
		:branching
	end

	def quoted_heading
		h.content_tag :b do "\"#{self.heading}\"" end
	end

	def go_to
		lbl =  h.content_tag :b do "Go To: " end
		lnk = h.link_to self.child_node.title, [self.child_node.story, self.child_node]
		(lbl + lnk).html_safe
	end

end
