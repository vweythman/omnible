module PageEditing

	def edit_bar
		h.alteration_toolkit(self)
	end

	def user_edit_bar
		h.content_tag :div, class:"toolkit alteration" do
			h.concat h.link_to_edit(self, false)
			h.concat h.link_to_delete(self, false)
		end
	end

end
