module FormHelper
	def form_field(label, entry)
		content_tag :div, class: 'field' do
			concat label
			concat entry
		end
	end

	def nested_fields(title, id, models, f, npartial, nlocals = {})
		capture do 
			concat nested_fields_top(title, id)
			concat nested_fields_loop(models, f, npartial, nlocals)
		end
	end

	def nested_fields_top(title, id)
		hide_link = content_tag :a, class: 'hide', id: "hide_#{id}" do "Hide #{title}" end
		heading   = content_tag :h3 do title end
		capture do 
			concat hide_link
			concat heading
		end
	end

	def nested_fields_loop(models, f, npartial, nlocals = {})
		index = 0
		f.fields_for models do |builder|
			nlocals[:f] = builder
			nlocals[:selector_id] = index
			index = index + 1
			concat render :partial => npartial, :locals => nlocals
		end
	end


	def show_link(title, id)
		content_tag :a, class: 'show', id: "show_#{id}" do "Show #{title}" end
	end

	def opinion_fields(f, collection, value)
		sl = collection.length / 2
		content_tag :fieldset, class: 'radio' do
			concat "<h3>#{value}</h3>".titleize.html_safe
			((-1 * sl)..(sl)).each do |i|
				concat form_field f.radio_button(value, i, :checked => (i == 0)), f.label("#{value}_#{i}", "#{collection[i + sl]}")
			end
		end
	end
end
