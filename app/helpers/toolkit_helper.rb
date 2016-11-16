module ToolkitHelper

	# AIDS
	# ============================================================
	def button_id(item_type)
		"button#{new_polymorphic_path(item_type).gsub('/', '-')}"
	end

	# GENERAL TOOLKITS
	# ============================================================
	def alterable_kit(item, kit_id, remoteness = false)
		content_tag :div, class:"toolkit alteration", id: kit_id do
			concat link_to_edit(item, remoteness)
			concat link_to_delete(item, remoteness)
		end
	end

	def creatable_kit(titleized_type, item_type, kit_id, remoteness)
		content_tag :div, class: "toolkit creation", id: kit_id do
			link_to_create(titleized_type, item_type, remoteness)
		end
	end

	def undestroyable_kit(model, remoteness = true)
		content_tag :div, class: "toolkit modification" do
			link_to_edit(item, remoteness)
		end
	end

	def response_kit(paths = {}, checked_status = {})
		user = current_user
		content_tag :div, class: "toolkit reader-response" do
			if !paths[:track].nil?
				concat link_to_track(paths[:track], checked_status[:track])
			end
			concat link_to_like(paths[:like], checked_status[:like])
			concat link_to_dislike(paths[:dislike], checked_status[:dislike])
		end
	end

	def directory_kit(sections = [])
		content_tag :div, class: "toolkit directory" do
			sections.each do |heading, path|
				concat link_to heading, path, class: "tool-link"
			end
		end if sections.length > 0
	end

	# TOOLKIT TYPE :: TABLE
	# ============================================================
	def creation_tablekit(kittype)
		content_tag :div, class: "toolkit creation" do
			link_to_create "Create", kittype
		end
	end

	def inline_alteration_toolblock(model)
		content_tag :td, class: "manager-editor", id: model.kit_id do
			alterable_kit(model, nil)
		end
	end

	def insertion_toolkit(heading, item_type)
		content_tag :div, class: "toolkit insertion" do
			link_to_create "New #{heading.to_s.titleize} Here", item_type
		end
	end

	def toolblock(colspan, toolkit)
		content_tag :tr do
			content_tag :td, colspan: colspan do
				toolkit
			end
		end
	end


	# TOOLKIT TYPES :: CREATION
	# ============================================================
	def creation_toolkit(name, item_type)
		if user_signed_in? 
			prechecked_creation_toolkit(name, item_type)
		end
	end

	def inline_creation_toolkit(name, item_type)
		creatable_kit(name.to_s.titleize, item_type, button_id(item_type), true)
	end

	def prechecked_creation_toolkit(name, item_type)
		creatable_kit(name.to_s.titleize, item_type, nil, false)
	end

	# TOOLKIT TYPES :: CREATION
	# ============================================================
	def alteration_toolkit(model)
		if user_signed_in? && model.editable?(current_user)
			alterable_kit(model, nil)
		end
	end

	def inline_alteration_toolkit(model)
		alterable_kit(model, model.kit_id, remoteness = true)
	end


	# TOOLKIT TYPES :: MULTI
	# ============================================================
	def multi_kit(model_types)
		if user_signed_in? 
			prechecked_createables(model_types)
		end
	end

	def prechecked_createables(types)
		content_tag :div, class: "multikit" do
			types.each do |type|
				concat prechecked_creation_toolkit (type.respond_to?('each') ? type.last : type), type
				concat " "
			end
		end
	end

end
