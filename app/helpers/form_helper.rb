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
	def nested_fields(f, nesting, nlocals = {})
		index = 0
		f.fields_for nesting.klass do |builder|
			nlocals[:f] = builder
			nlocals[:selector_id] = index
			index = index + 1
			concat render :partial => nesting.partial, :locals => nlocals
		end
	end

	def taggables(label, list, title = nil, placeholder = nil)
		form_field label_tag(label, title), text_field_tag(label, list.join(";"), :placeholder => placeholder, class: 'taggables')
	end

end
