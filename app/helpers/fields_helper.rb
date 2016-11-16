module FieldsHelper

	# FORM FIELDS
	# ============================================================
	def field_content_tag(field_block, type)
		content_tag :div, class: "field-content field-#{type}" do
			field_block
		end
	end

	def selection_field_cell(field, values, heading, options = {})
		content_tag :div, class: "field-box selection-field" do
			concat field_content_tag(label_tag(field, heading), :label)
			concat field_content_tag(select_tag(field, values, options), :value)
		end
	end

	def toggle_field_cell(group, id, status, options = {})
		options[:data] ||= {}
		options[:data]["toggle-id"] = id
		options[:class] = "switch"

		val = "#{group}-#{id}"
		
		content_tag :div, class: "field-box switch-field" do
			concat check_box_tag(val, val, status, options)
			concat label_tag(val, "")
		end
	end

	# FORM FIELDS // FILTERS
	# ============================================================
	def filter_selects(type, filters, heading = nil)
		current = params[type]
		heading = type.to_s.humanize if heading.nil?
		list    = []

		filters.map {|f| list << [f[:key], f[:heading]] }
		values = options_from_collection_for_select(list, :first, :last, current)

		selection_field_cell(type, values, heading, class: "filter-selection-links")
	end

	def filter_submit_tag
		content_tag :div, class: "field-box submit-field" do
			submit_tag("Filter", name: nil)
		end
	end

	def filter_tags(choice, label)
		values = select_filter_param choice
		tag_field_cell(choice, values.split(";"), label)
	end

	def select_filter_param(list)
		find = params
		(0..(list.size - 1)).map do |i|
			find = find[list[i]]

			if find.nil?
				return ""
			end
		end
		return find
	end

	# FORM FIELDS // TAGS
	# ============================================================
	def tag_field_cell(label, values, heading = nil, options = {})
		options[:class] ||= ""
		options[:class] += 'taggables'

		field_name = label.join("-").to_s.underscore
		field_name.gsub!(/_/, '-')
		field_name.gsub!(/\]\[/, '-')
		field_name.gsub!(/(\[|\])/, '')


		content_tag :div, class: "field-box #{field_name}-field taggable-field" do
			concat field_content_tag(label_tag(taggables_label(label), heading, class: 'taggables-label'), :label)
			concat field_content_tag(text_field_tag(taggables_label(label), values.join(";"), options), :value)
		end
	end

	def taggables_label(label)
		label.map{|t| "[#{t}]" }.join("")
	end

	# RENDERED FIELDS
	# ============================================================
	# OUTPUT form field
	def form_field(first_element, second_element)
		content_tag :div, class: 'field' do
			concat first_element
			concat second_element
		end
	end

	def preview_area(src)
		content_tag :div, class: "preview-area" do
			image_tag(src, alt: "image preview", class: "image-preview")
		end
	end

end
