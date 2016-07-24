module WidgetsHelper

	def to_snippet
		"shared/widgets/snippet"
	end

	def to_paginated_panel
		'shared/results/paged'
	end
	
	def paginated_panel(rst, sz = "golden-major")
		render :layout => 'shared/results/paged', :locals => { results: rst, panel_size: sz } do
			yield
		end
	end

	def index_panel(title, sz = "solo")
		render :layout => 'shared/results/block', :locals => { index_heading: title, panel_size: sz } do
			yield
		end
	end

end
