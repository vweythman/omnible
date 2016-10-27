module PageEditing

	# 1. PUBLIC DISPLAY METHODS
	# ============================================================
	# edit_bar - toolkit blocks for creators on page display
	# ............................................................
	def edit_bar
		h.alteration_toolkit(self)
	end

	# user_edit_bar - toolkit blocks for creators in table display
	# ............................................................
	def user_edit_bar
		h.content_tag :div, class:"toolkit alteration" do
			h.concat h.link_to_edit(self, false)
			h.concat h.link_to_delete(self, false)
		end
	end

	# reader_response_bar - toolkit blocks for readers
	# ............................................................
	def reader_response_bar
	end

	# response_bar - toolkit blocks for users
	# ............................................................
	def response_bar
		if being_read_by_editor?
			edit_bar
		elsif being_read_nonanon?
			reader_response_bar
		end
	end

	# 2. PUBLIC QUESTION METHODS
	# ============================================================
	# being_read_nonanon? - creator is logged in and reading
	# ............................................................
	def being_read_by_editor?
		editable? h.current_user
	end

	# being_read_nonanon? - reader is logged in
	# ............................................................
	def being_read_nonanon?
		h.current_user.present?
	end

end
