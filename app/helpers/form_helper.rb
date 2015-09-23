module FormHelper
	# OUTPUT form field
	def form_field(first_element, second_element)
		content_tag :div, class: 'field' do
			concat first_element
			concat second_element
		end
	end
	
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

	# OUTPUT existing content for nested field
	def nested_fields(f, collection, nlocals = {})
		index = 0
		f.fields_for collection.klass do |builder|
			
			nlocals[:f]           = builder
			nlocals[:selector_id] = index

			index = index + 1
			concat render :partial => collection.partial, :locals => nlocals
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

			tagid  = "#{param}_#{idx}"
			label = collection[idx]
			output = output + form_field(f.radio_button(param, num, :checked => is_checked), f.label(tagid, label))
		end

		content_tag :div, class: "choice" do
			output.html_safe
		end
	end

	def taggables(label, list, title = nil, placeholder = nil)
		form_field label_tag(label, title), text_field_tag(label, list.join(";"), :placeholder => placeholder, class: 'taggables')
	end

end
