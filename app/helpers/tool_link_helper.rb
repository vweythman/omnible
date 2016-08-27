module ToolLinkHelper
	
	def link_to_create(title, type, remoteness = false)
		link_to "+ #{title}", new_polymorphic_path(type), remote: remoteness
	end

	def link_to_edit(item, remoteness = false)
		link_to t('toolkit.edit'), edit_polymorphic_path(item), remote: remoteness, class:"icon icon-cog"
	end

	def link_to_delete(item, remoteness = false)
		link_to t('toolkit.delete'), item, class:"icon icon-bin", method: :delete, remote: remoteness , data: { confirm: "Are you sure you want to delete #{item.heading}?"} 
	end

	def link_to_watch(path, checked = false)
		checked_status, method_type = response_switch checked
		link_to t('toolkit.' + checked_status + '.watch'), path, class: "icon icon-eye #{checked_status}", id: 'watch-link', remote: true, method: method_type
	end

	def link_to_like(path, checked = false)
		checked_status, method_type = response_switch checked
		link_to t('toolkit.' + checked_status + '.like'), path, class: "icon icon-heart #{checked_status}", id: 'work-like', remote: true, method: method_type
	end

	def link_to_dislike(path, checked = false)
		checked_status, method_type = response_switch checked
		link_to t('toolkit.' + checked_status + '.dislike'), path, class: "icon icon-heart-broken #{checked_status}", id: 'work-dislike', remote: true, method: method_type
	end

	def response_switch(checked)
		if checked
			['checked', :delete]
		else
			['unchecked', :post]
		end
	end

end
