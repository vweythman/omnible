module ContentHelper

	def dashboard_header(subs = [], hid = nil)
		content_tag :header, class: "dashboard-header" do
			concat dash_heading subs, hid
			yield if block_given?
		end
	end

	def dash_heading(s, hid)
		content_tag :h1, id: hid do
			concat "Your Dashboard"
			concat subtitles(s)
		end
	end

	def subtitles(s)
		capture do
			s.each do |t|
				concat subtitle t
			end
		end
	end

	# OUTPUT correct article
	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	def metadata(ky, val)
		key_string = content_tag :b, class: "key" do (ky) end
		content_tag :p do
			"#{key_string} #{val}".html_safe
		end
	end

	# OUPUT item label tag
	def subtitle(heading)
		content_tag :span, class: "subtitle" do heading end
	end

	# OUPUT item label tag
	def title(heading)
		content_tag :span, class: "title" do heading end
	end
	
	def time_label(heading)
		content_tag :span, class: "time-label" do heading end
	end

	def page_widget(heading, options = {})
		cell_type = options[:type]
		cell_type ||= "solo"

		if cell_type == "solo"
			solo_cell(cell_type) do
				widget_cell(heading, options) do
					yield
				end
			end
		else
			panel_cell(cell_type) do
				widget_cell(heading, options) do
					yield
				end
			end
		end
	end

	def subheading(heading)
		content_tag :h2, class: "subheading" do
			heading
		end
	end

	def snippet_partial
		"shared/snippets/snippet"
	end

	def widget_cell(heading, options = {})
		widget_classes = ["widget", "page-widget", options[:class]].join(" ").strip
		widget_id      = options[:id]

		content_tag :div, class: widget_classes, id: widget_id do
			concat subheading(heading)
			yield
		end
	end

end
