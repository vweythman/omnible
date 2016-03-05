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

	# FIELDSETS
	# ------------------------------------------------------------
	# OUTPUT nested fields heading
	def nested_legend(nesting)
		heading = content_tag :legend do "#{nesting.heading} #{hide_link(nesting.klass)}".html_safe end
	end

	# OUTPUT hide toggle
	def hide_link(id)
		render :partial => "shared/forms/hide_toggle", :locals => { :hide_id => "hide_#{id}" }
	end

	# OUTPUT show toggle
	def show_link(title, id)
		render :partial => "shared/forms/show_toggle", :locals => { :show_id => "show_#{id}", :title => title }
	end

	def taggables_label(label)
		label.map{|t| "[#{t}]" }.join("")
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
