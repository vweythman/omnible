module WordCountable

	def heading_with_count
		(heading + " " + length_span).html_safe
	end

	def length_span
		h.content_tag :span, class: "word-count" do
			length_status
		end
	end

	def length_status
		h.number_with_delimiter(self.word_count, :delimiter => ",") + " Words"
	end
	
	def length_data
		h.content_tag :td, :data => {:label => "Word Count"} do
			length_status
		end
	end

end