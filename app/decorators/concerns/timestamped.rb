module Timestamped

	# Labels
	# ------------------------------------------------------------
	def started_label
		"Uploaded"
	end

	def most_recent_label
		"Updated"
	end

	# Tags
	# ------------------------------------------------------------
	def timestamps
		time = started_label + ": " + h.timestamp(created_at).html_safe
		unless just_created?
			time = time + " " + most_recent_label  + ": " + h.timestamp(updated_at).html_safe
		end
		h.content_tag :p, class: 'time' do
			time.html_safe
		end
	end

	def creation_data
		h.content_tag :td, :data => {:label => "Creation Date"} do
			h.record_time self.created_at
		end
	end

	def updated_at_data
		h.content_tag :td, :data => {:label => "Update Date"} do
			h.record_time self.updated_at
		end
	end
	
end