module InlineEditing

	# GET
	# ============================================================
	def form_finder
		"#" + form_id
	end

	def tag_finder
		"#" + tag_id
	end

	def kit_finder
		"#" + kit_id
	end

	# SET
	# ============================================================
	def tag_id
		"#{klass}-#{self.id}"
	end
	
	def kit_id
		"#{klass}-edit-bar-for-#{self.id}"
	end

	def form_id
		h.edit_form_id(klass, self.id)
	end

	# RENDER
	# ============================================================
	def edit_bar
		h.inline_alteration_toolkit(self)
	end

	def edit_block
		h.inline_alteration_toolblock(self)
	end

	def edit_form_div
		h.form_div_for_ajaxed_edit(klass, object.id)
	end

end