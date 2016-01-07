module PanelableCollection

	def panel_heading
		(heading + " " + counter).html_safe
	end

	def counter
		h.content_tag :span, class: "counter" do self.length.to_s end
	end

end
