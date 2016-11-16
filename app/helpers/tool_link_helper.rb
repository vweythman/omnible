module ToolLinkHelper
	
	# SPECIFIED TOOL LINK METHODS
	# ============================================================
	def link_to_create(title, type, remoteness = false)
		link_to "+ #{title}", new_polymorphic_path(type), remote: remoteness, class: "tool-link"
	end

	def link_to_edit(item, remoteness = false)
		tool_link 'toolkit.edit', edit_polymorphic_path(item), remote: remoteness, class: "icon icon-cog tool-link"
	end

	def link_to_delete(item, remoteness = false)
		tool_link 'toolkit.delete', item, class: "icon icon-bin tool-link", method: :delete, remote: remoteness , data: { confirm: "Are you sure you want to delete #{item.heading}?"} 
	end

	def link_to_track(path, checked = false)
		response_link 'watch', path, 'eye', checked
	end

	def link_to_like(path, checked = false)
		response_link 'like', path, 'heart', checked
	end

	def link_to_dislike(path, checked = false)
		response_link 'dislike', path, 'heart-broken', checked
	end

	# TEXT OUTPUT
	# ============================================================
	def response_switch(checked)
		if checked
			['checked', :delete]
		else
			['unchecked', :post]
		end
	end

	# TOOL LINK METHODS
	# ============================================================
	def response_link(type, path, icon, checked)
		checked_status, method_type = response_switch checked
		tool_link 'toolkit.' + checked_status + '.' + type, path, class: "icon icon-#{icon} #{checked_status} tool-link", id: type + '-link', remote: true, method: method_type
	end

	def tool_link(heading, path, options = {})
		span_tag = content_tag :span, class: "tool-value" do t(heading) end
		link_to span_tag, path, options
	end

end
