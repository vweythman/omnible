module CreativeContent
	module Composition

		# GET
		# ============================================================
		def heading_with_count
			(heading + " " + length_span).html_safe
		end

		def heading_with_icon
			(icon + " " + heading).html_safe
		end

		# SET
		# ============================================================
		def length_status
			@length_status ||= h.number_with_delimiter(self.word_count, :delimiter => ",") + " Words"
		end

		def status_label
			@status_label ||= complete? ? "Complete" : "Incomplete"
		end

		def title_for_creation
			@meta_title ||= "Create #{klass}".titleize
		end

		def title_for_editing
			@meta_title ||= heading + " (Editing)"
		end

		# RENDER
		# ============================================================
		def length_span
			h.content_tag :span, class: "word-count" do
				length_status
			end
		end
		
		def length_data
			h.content_tag :td, :data => {:label => "Word Count"} do
				length_status
			end
		end

	end
end