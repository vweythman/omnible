module InlineEditing

	def edit_bar
		h.inline_alteration_toolkit(self)
	end

	def edit_form_div
		h.form_div_for_ajaxed_edit(klass, object.id)
	end

	def formid
		"#" + h.edit_form_id(klass, object.id)
	end

end
