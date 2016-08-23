module FormHelper

	# PAGE FORMS
	# ------------------------------------------------------------
	def creation_block(title)
		content_tag :div, class: "generator new" do
			concat (content_tag :h1, class: "form-title" do title end)
			yield
		end
	end

	def editing_block(title)
		content_tag :div, class: "generator edit" do
			concat (content_tag :h1, class: "form-title" do title end)
			yield
		end
	end

	def clean_form_for(model, options = {})
		options[:builder] = Builders::CleanBuilder
		form_for(model, options) do |f|
			yield(f)
		end
	end

	# FIELDSETS
	# ------------------------------------------------------------
	def nestset(models)
		content_tag :fieldset, class: models.nest_class, id: models.formid do
			concat models.legend
			yield
		end
	end

	def tagset(setlegend, options = {})
		options[:class] ||= ""
		curr_class = [options[:class], 'nested-tags-fieldset']
		options[:class] = curr_class.join " "

		content_tag :fieldset, options do 
			concat (content_tag :legend do setlegend end)
			yield
		end
	end

	def error_block(model)
		errors = model.errors
		if errors.any?
			heading = content_tag :h2 do pluralize(errors.count, "Error") end

			content_tag :div, class: 'error-explanation' do
				concat heading
				concat error_items(errors)
			end
		end
	end

	def error_items(errors)
		content_tag :ul do
			errors.full_messages.collect {|error| concat(content_tag(:li, class: 'icon icon-bug') do " #{error}" end)}
		end
	end

	# FIELDSETS ELEMENTS
	# ------------------------------------------------------------
	# OUTPUT nested fields heading
	def nested_legend(nesting)
		heading = content_tag :legend do "#{nesting.heading} #{hide_link(nesting.klass)}".html_safe end
	end

	# OUTPUT hide toggle
	def hide_link(id)
		content_tag :div, class: "hide-cell" do
			content_tag :span, class: "hide-toggle", id: "hide_#{id}" do "&uArr; Hide".html_safe end
		end
	end

	# OUTPUT show toggle
	def show_link(title, id)
		content_tag :div, class: "show-cell" do
			content_tag :span, class: "show-toggle", id: "show_#{id}" do "&dArr; View #{ title }".html_safe end
		end
	end

	# AJAX EDIT FORM
	# ------------------------------------------------------------
	def form_div_for_ajaxed_edit(type, id)
		content_tag :div, class: "editor-block", id: edit_form_id(type, id), style: "display:none;" do "" end
	end

	def form_div_for_ajaxed_creation(type)
		content_tag :div, class: "creation-block", id: type + "-form", style: "display:none;" do "" end
	end

	def edit_form_id(type, id)
		type.to_s + "-form-for-" + id.to_s
	end

	def ajaxed_form_render(form_partial = "form")
		render :partial => form_partial, :locals => { :remote => true }
	end

end
