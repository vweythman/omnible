module ToolLinkHelper
	
	def link_to_create(title, type, remoteness = false)
		link_to "+ #{title}", new_polymorphic_path(type), remote: remoteness
	end

	def link_to_edit(item, remoteness = false)
		link_to 'Edit', edit_polymorphic_path(item), remote: remoteness, class:"icon icon-cog"
	end

	def link_to_delete(item, remoteness = false)
		link_to 'Delete', item, class:"icon icon-bin", method: :delete, remote: remoteness , data: { confirm: "Are you sure you want to delete #{item.heading}?"} 
	end

end
