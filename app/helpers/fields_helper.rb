module FieldsHelper

	# RENDERED FIELDS
	# ------------------------------------------------------------
	# -- Panels
	# ............................................................
	# OUTPUT [true/false] checkbox
	def boolean_field(f, value, heading = nil)
		heading = value if heading.nil?

		render :partial => "shared/forms/panel/boolean", :locals => { :f => f, :boolean_value => value, :boolean_label => heading }
	end

	# OUTPUT single line text field
	def string_panel(f, value,  placeholder = nil)
		render :partial => "shared/forms/panel/string", :locals => { :f => f, :value => value, :placeholder => placeholder }
	end

	# OUTPUT single line text field
	def selectables(f, value, group)
		render :partial => "shared/forms/panel/selectables", :locals => { :f => f, :value => value, :group => group }
	end

	# OUTPUT single line text field
	def submit_panel(f)
		render :partial => "shared/forms/panel/submit", :locals => { :f => f }
	end

	# OUTPUT text field tags
	def taggables(label, list, title = nil, placeholder = nil)
		render :partial => "shared/forms/panel/tag", :locals => { :label => label, :title => title, :tagline => list.join(";"), :placeholder => placeholder }
	end

	def text_panel(f, value, size, placeholder = nil)
		render :partial => "shared/forms/panel/text", :locals => { :f => f, :value => value, :size => size, :placeholder => placeholder }
	end

	# -- GROUPS
	# ............................................................
	# OUTPUT multiple checkboxes
	def choose_any(f, value, collection)
		render :partial => "shared/forms/choose_any", :locals => { :f => f, :value => value, :collection => collection }
	end

	def nested_partial
		"shared/forms/nested"
	end

	# RENDERED FIELDS
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

end
