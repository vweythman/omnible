module GridHelper

	def grid_panel(panel_class = nil)
		cgroup = "grid-panel"
		unless panel_class.nil?
			cgroup += " " + panel_class
		end

		content_tag :div, class: cgroup do
			yield
		end
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

	def panel_cell(cell_size = "solo")
		content_tag :div, class: "panel-cell #{cell_size}" do
			yield
		end
	end

	def solo_cell(panel_class = nil)
		grid_panel panel_class do
			panel_cell do yield end
		end
	end

	def subheading(heading)
		content_tag :h2, class: "subheading" do
			heading
		end
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
