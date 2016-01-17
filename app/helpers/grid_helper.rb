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

end
