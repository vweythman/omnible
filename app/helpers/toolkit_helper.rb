module ToolkitHelper

	# CREATION
	# ------------------------------------------------------------
	def creation_toolkit(name, item_type)
		if user_signed_in? 
			prechecked_creation_toolkit(name, item_type)
		end
	end

	def inline_creation_toolkit(name, item_type)
		render(:partial => "shared/toolkits/createable", :locals => { :titleized_type => name.to_s.titleize, :item_type => item_type, :remoteness => true, :kit_id => button_id(item_type) })
	end

	def insertion_toolkit(heading, item_type)
		render(:partial => "shared/toolkits/insertable", :locals => { :titleized_type => heading.to_s.titleize, :item_type => item_type })
	end

	def prechecked_creation_toolkit(name, item_type)
		render(:partial => "shared/toolkits/createable", :locals => { :titleized_type => name.to_s.titleize, :item_type => item_type, :remoteness => false, :kit_id => nil })
	end

	def button_id(item_type)
		"button#{new_polymorphic_path(item_type).gsub('/', '-')}"
	end

	# EDITING & DESTROYING
	# ------------------------------------------------------------
	def alteration_toolkit(model)
		if user_signed_in? && model.editable?(current_user)
			render(:partial => "shared/toolkits/alterable", :locals => { :item => model, :remoteness => false, :kit_id => nil } )
		end
	end

	def inline_alteration_toolkit(model)
		render(:partial => "shared/toolkits/alterable", :locals => { :item => model, :remoteness => true, :kit_id => model.kit_id } )
	end

	def inline_alteration_toolblock(model)
		render(:partial => "shared/toolkits/inline_manager_block", :locals => { :item => model } )
	end

	def inline_undestroyable_toolkit(model, remoteness = true)
		render(:partial => "shared/toolkits/undestroyable", :locals => { :item => model, :remoteness => remoteness } )
	end

	def edit_link(item, remoteness = false)
		link_to 'Edit', edit_polymorphic_path(item), remote: remoteness, class:"icon icon-cog"
	end

	def delete_link(item, remoteness = false)
		link_to 'Delete', item, class:"icon icon-bin", method: :delete, remote: remoteness , data: { confirm: "Are you sure you want to delete #{item.heading}?"} 
	end

	# FORMATING
	# ------------------------------------------------------------
	def toolblock(colspan, toolkit)
		render(:partial => "shared/toolkits/table_toolblock", :locals => { :toolkit => toolkit, :colspan => colspan } )
	end

	# UNSPECIFIED
	# ------------------------------------------------------------
	def multi_kit(model_types, toolkit_type = :creation)
		if user_signed_in? 
			prechecked_multi_kit(model_types, toolkit_type)
		end
	end

	def prechecked_multi_kit(model_types, toolkit_type = :creation)
		render :partial => "shared/toolkits/multi_#{toolkit_type}_kits", :locals => { :types => model_types }
	end

end
