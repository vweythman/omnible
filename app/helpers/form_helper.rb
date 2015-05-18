module FormHelper
	# OUTPUT form field
	def form_field(first_element, second_element)
		content_tag :div, class: 'field' do
			concat first_element
			concat second_element
		end
	end

	# OUTPUT nested field values without closing tag
	def nested_fields(nesting, f, nlocals = {})
		capture do 
			concat nested_fields_top(nesting.heading, nesting.klass)
			concat nested_fields_loop(nesting.klass, f, nesting.partial, nlocals)
		end
	end

	# OUTPUT nested fields heading
	def nested_fields_top(title, id)
		heading   = content_tag :legend do title end
		hide_p    = hide_link(title, id)
		capture do 
			concat heading
			concat hide_p
		end
	end

	# OUTPUT hide toggle
	def hide_link(title, id)
		hide_link = content_tag :a, class: 'hide' , id: "hide_#{id}" do "&uArr; Hide".html_safe end
		hide_p    = content_tag :p, class: 'hider' do hide_link end
	end

	# OUTPUT show toggle
	def show_link(title, id)
		content_tag :a, class: 'show', id: "show_#{id}" do "&dArr; View #{title}".html_safe end
	end

	# OUTPUT existing content for nested field
	def nested_fields_loop(models, f, npartial, nlocals = {})
		index = 0
		f.fields_for models do |builder|
			nlocals[:f] = builder
			nlocals[:selector_id] = index
			index = index + 1
			concat render :partial => npartial, :locals => nlocals
		end
	end

	# OUTPUT choices on a scale 
	def scale_fields(f, collection, value, def_selection)
		pivot   = collection.length / 2
		heading = content_tag :legend do "#{value}".titleize end

		choice  = content_tag :div, class: 'choice' do 
			((-1 * pivot)..(pivot)).each do |i|
				concat form_field f.radio_button(value, i, :checked => (i == def_selection)), f.label("#{value}_#{i}", "#{collection[i + pivot]}")
			end
		end

		set_options(heading, choice)
	end

	# OUTPUT general choices
	def radio_fields(f, collection, value, def_selection)
		max     = collection.length - 1
		heading = content_tag :legend do "#{value}".titleize end
		
		choice  = content_tag :div, class: 'choice' do 
			(0..max).each do |i|
				concat form_field f.radio_button(value, i, :checked => (i == def_selection)), f.label("#{value}_#{i}", "#{collection[i]}")
			end
		end

		set_options(heading, choice)
	end

	# OUTPUT options field
	def set_options(heading, choice)
		content_tag :fieldset, class: 'options' do
			concat heading
			concat choice
		end
	end

end
