module FormHelper
	
	# FIELDSETS
	# ------------------------------------------------------------
	# OUTPUT nested fields heading
	def nested_legend(nesting)
		heading = content_tag :legend do "#{nesting.heading} #{hide_link(nesting.klass)}".html_safe end
	end

	# OUTPUT hide toggle
	def hide_link(id)
		hide_link    = content_tag :a, class: 'hide' , id: "hide_#{id}" do "&uArr; Hide".html_safe end
		hide_enclose = content_tag :span, class: 'hider' do hide_link end
	end

	# OUTPUT show toggle
	def show_link(title, id)
		content_tag :a, class: 'show', id: "show_#{id}" do "&dArr; View #{title}".html_safe end
	end
	
	# FIELDS
	# ------------------------------------------------------------
	# OUTPUT form field
	def form_field(first_element, second_element)
		content_tag :div, class: 'field' do
			concat first_element
			concat second_element
		end
	end

	# OUTPUT choice div
	def choice(output)
		content_tag :div, class: "choice" do
			output.html_safe
		end
	end

	# OUTPUT radio buttons
	def radios(f, param, collection, default = 0, offset = 0)
		max = collection.length - 1
		min = 0
		output = " "

		(min..max).each do |idx|
			num        = idx + offset
			is_checked = idx == default

			tagid = "#{param}_#{idx}"
			field = f.radio_button(param, num, :checked => is_checked)
			label = f.label(tagid, collection[idx])

			output = output + form_field(field, label)
		end

		choice output
	end

	# OUTPUT radio buttons using string
	def radios_by_string(f, param, collection, default = "")
		output = ""
		collection.each do |v|
			is_checked = (v == default)

			tagid = "#{param}_#{v.downcase.tr(" ", "_")}"
			field = f.radio_button(param, v, :checked => is_checked)
			label = f.label(tagid, v)

			output = output + form_field(field, label)
		end

		choice output
	end

	# OUTPUT tag text field
	def taggables(label, list, title = nil, placeholder = nil)
		render :partial => "shared/forms/tag_input_field", :locals => { :label => label, :title => title, :tagline => list.join(";"), :placeholder => placeholder }
	end

	def boolean_field(f, value, heading = nil)
		heading = value if heading.nil?

		render :partial => "shared/forms/boolean_field", :locals => { :f => f, :boolean_value => value, :boolean_label => heading }
	end

	# AJAX EDIT FORM
	def form_div_for_ajaxed_edit(type, id)
		content_tag :div, id: edit_form_id(type, id), style: "display:none;" do "" end
	end

	def form_div_for_ajaxed_creation(type)
		content_tag :div, class: "creation-block", id: type + "-form", style: "display:none;" do "" end
	end

	def edit_form_id(type, id)
		type + "-form-for-" + id.to_s
	end

	def ajaxed_form_render
		render :partial => "form", :locals => { :remote => true }
	end

end
