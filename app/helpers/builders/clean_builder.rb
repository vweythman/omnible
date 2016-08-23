module Builders
	class CleanBuilder < ActionView::Helpers::FormBuilder

		# PUBLIC METHOD
		# ============================================================
		# SINGLETONS
		# ------------------------------------------------------------
		def boolean_cell(value, heading = nil, options = {})
			field_box(value, :decision) do
				checkbox_plus(value, heading, options)
			end
		end

		def drop_selection_cell(field, values, heading, soptions = {}, toptions = {})
			field_box(field, :selection) do
				@template.concat field_content(self.label(field, heading), :label)
				@template.concat field_content(select(field, @template.options_for_select(values, soptions), toptions), :value)
			end
		end

		def email_cell(options = {})
			options[:autofocus] ||= true

			field_box(:email, :string) do
				@template.concat field_content(self.label(:email), :label)
				@template.concat field_content(text_field(:email, options), :value)
			end
		end

		def file_cell(value, heading, options = {})
			field_box(value, :file) do
				@template.concat field_content(self.label(value, heading), :label)
				@template.concat field_content(file_field(value, options), :value)
			end
		end

		def password_cell(value, options = {})
			options[:autofocus]    ||= true
			options[:autocomplete] ||= "off"

			field_box(value, :string) do
				@template.concat field_content(self.label(value), :label)
				@template.concat field_content(password_field(value, options), :value)
			end
		end

		def selectable_cell(field, values, soptions = {}, toptions = {})
			toptions[:class] = "selectables"
			selection_cell(field, values, nil, :id, :heading, soptions, toptions)
		end

		def selection_cell(field, values, heading, id, title, sopts = {}, toptions = {})
			field_box(field, :selection) do
				@template.concat field_content(self.label(field, heading), :label)
				@template.concat field_content(collection_select(field, values, id, title, sopts, toptions), :value)
			end
		end

		def radio_cell(param, value, heading, options = {})
			field_box(param, :selection) do
				@template.concat radio_button(param, value, options)
				@template.concat self.label(heading, value, class: 'field-value')
			end
		end

		def string_cell(value, heading, options = {})
			options[:title] = heading.to_s

			field_box(value, :string) do
				@template.concat field_content(self.label(value, heading), :label)
				@template.concat field_content(text_field(value, options), :value)
			end
		end

		def submit_cell(heading = nil)
			@template.content_tag :div, class: "field-box submit-field" do
				submit heading
			end
		end

		def text_cell(value, options = {}, is_optional = false)
			heading = is_optional ? value.to_s.humanize + " (Optional)" : nil

			field_box(value, :text) do
				@template.concat field_content(self.label(value, heading), :label)
				@template.concat field_content(text_area(value, options), :value)
			end
		end

		# GROUPED FIELDS
		# ------------------------------------------------------------
		def listed_radios(field, values, default = 0, options = {})
			group = (0..(values.length - 1)).map do |idx|
				options[:checked] = (idx == default)

				field_box(field, :selection) do
					@template.concat radio_button(field, idx, options)
					@template.concat self.label("#{field}_#{idx}", values[idx], class: 'field-value')
				end
			end

			boxed_fields(field, :choice) do
				group.join.html_safe
			end
		end

		def multiple_choice(field, values, options = {})
			field_name = field.to_s.singularize

			boxed_fields(field, :multichoice) do
				collection_check_boxes(field, values, :id, :heading) do |b|
					field_box(field_name, :decision) do
						b.check_box + b.label { "<span class='field-value'></span><span class='field-label'>#{b.text}</span>".html_safe }
					end
				end
			end
		end

		def strung_radios(param, values, default, options = {})
			group = values.map do |val|
				options[:default] = (val == default)
				heading = "#{param}_#{val.downcase.tr(" ", "_")}"

				radio_cell(param, val, heading, options)
			end

			boxed_fields(param, :choice) do
				group.join.html_safe
			end
		end

		def checkbox_plus(value, heading = nil, copts = {}, lopts = {})
			heading = value.to_s.humanize if heading.nil?

			@template.capture do
				@template.concat check_box(value, copts)
				@template.concat self.label(value, "<span class='field-value'></span><span class='field-label'>#{heading}</span>".html_safe, lopts)
			end
		end

		def edit_and_view_fields
			@template.render 'shared/forms/edit_fields', f: self
		end

		def view_fields
			@template.render 'shared/forms/view_fields', f: self
		end

		# PRIVATE METHOD
		# ============================================================
		private

		def boxed_fields(group_name, group_type)
			group_name = group_name.to_s.underscore
			group_name.gsub!(/_/, '-')
			@template.content_tag :div, class: "fields #{group_type}-fields #{group_name}-fields" do
				yield
			end
		end

		def field_box(field_name, type)
			field_name = field_name.to_s.underscore
			field_name.gsub!(/_/, '-')
			@template.content_tag :div, class: "field-box #{type}-field #{field_name}-field" do
				yield
			end
		end

		def field_content(field_block, type)
			@template.content_tag :div, class: "field-content field-#{type}" do
				field_block
			end
		end

	end
end
