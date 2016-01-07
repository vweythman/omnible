module ToolkitHelper

	# CREATION
	# ------------------------------------------------------------
	def creation_toolkit(name, item_type)
		if user_signed_in? 
			prechecked_creation_toolkit(name, item_type)
		end
	end

	def inline_creation_toolkit(name, item_type)
		render(:partial => "shared/toolkits/inline_createable", :locals => { :titleized_type => name.to_s.titleize, :item_type => item_type })
	end

	def insertion_toolkit(heading, item_type)
		render(:partial => "shared/toolkits/insertable", :locals => { :titleized_type => heading.to_s.titleize, :item_type => item_type })
	end

	def prechecked_creation_toolkit(name, item_type)
		render(:partial => "shared/toolkits/createable", :locals => { :titleized_type => name.to_s.titleize, :item_type => item_type })
	end

	# EDITING & DESTROYING
	# ------------------------------------------------------------
	def alteration_toolkit(model)
		if user_signed_in? && model.editable?(current_user)
			render(:partial => "shared/toolkits/alterable", :locals => { :item => model } )
		end
	end

	def inline_alteration_toolkit(model)
		render(:partial => "shared/toolkits/inline_alterable", :locals => { :item => model } )
	end

	def inline_undestroyable_toolkit(model)
		render(:partial => "shared/toolkits/inline_undestroyable", :locals => { :item => model } )
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
