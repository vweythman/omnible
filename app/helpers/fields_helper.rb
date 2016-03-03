module FieldsHelper

	# RENDERED FIELDS
	# ------------------------------------------------------------
	# -- Panels
	# ............................................................
	# OUTPUT [true/false] checkbox
	def boolean_field(f, value, heading = nil)
		render :partial => "shared/forms/panel/boolean", :locals => { :f => f, :boolean_value => value, :boolean_label => heading }
	end

	# OUTPUT single line text field
	def input_email(f)
		render :partial => "shared/forms/panel/email", :locals => { :f => f }
	end

	# OUTPUT single line text field
	def input_password(f, value)
		render :partial => "shared/forms/panel/password", :locals => { :f => f, :value => value }
	end

	# OUTPUT single line text field
	def string_panel(f, value,  placeholder = nil, heading = nil)
		render :partial => "shared/forms/panel/string", :locals => { :f => f, :value => value, :heading => heading, :placeholder => placeholder }
	end

	# OUTPUT single line text field
	def selectables(f, value, group)
		render :partial => "shared/forms/panel/selection", :locals => { :f => f, :value => value, :group => group, :select_class => "selectables", :selected_value => nil }
	end

	# OUTPUT single line text field
	def selection_panel(f, value, group, s = nil, sc = nil)
		render :partial => "shared/forms/panel/selection", :locals => { :f => f, :value => value, :group => group, :selected_value => s, :select_class => sc}
	end

	# OUTPUT single line text field
	def simple_selection_panel(value, options, t = nil)
		render :partial => "shared/forms/panel/simple_selection", :locals => { :value => value, :options => options, :title => t }
	end

	# OUTPUT single line text field
	def submit_panel(f, heading = nil)
		render :partial => "shared/forms/panel/submit", :locals => { :f => f, :heading => heading }
	end

	# OUTPUT text field tags
	def taggables(label, list, title = nil, placeholder = nil)
		render :partial => "shared/forms/panel/tag", :locals => { :label => label, :title => title, :tagline => list.join(";"), :placeholder => placeholder }
	end

	def text_panel(f, value, size, placeholder = nil)
		render :partial => "shared/forms/panel/text", :locals => { :f => f, :value => value, :size => size, :placeholder => placeholder }
	end

	def toggle_panel(group, id, is_checked)
		render :partial => "shared/forms/panel/toggle", :locals => { val: "#{group}-#{id}", id: id, is_checked: is_checked }
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

	# OUTPUT radio buttons
	def radios(f, p, c, d = 0, o = 0)
		mx = c.length - 1
		mn = 0
		render :partial => "shared/forms/radio_fields", :locals => { 
			:f => f, :param => p, :collection => c, :mx => mx, :mn => mn, :default => d, :offset => o
		}
	end

	def radio_set(f, p, c, t = "Select", d = 0)
		render :partial => "shared/forms/radio_fieldset", :locals => { 
			:f => f, :param => p, :collection => c, :default => d, :title => t
		}
	end

	# OUTPUT radio buttons using string
	def radios_by_string(f, p, c, d = "")
		render :partial => "shared/forms/radio_strings", :locals => { 
			:f => f, :param => p, :collection => c, :default => d
		}
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

end
