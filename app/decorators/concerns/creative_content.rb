module CreativeContent

	# GET
	# ============================================================
	def time_started
		started_label + ": " + h.timestamp(created_at).html_safe
	end

	def time_updated
		most_recent_label  + ": " + h.timestamp(updated_at).html_safe
	end

	def by_uploader
		("By " + h.link_to(uploader.name, uploader)).html_safe
	end

	# SET
	# ============================================================
	def icon_choice
		'file-empty'
	end

	def started_label
		"Uploaded"
	end

	def most_recent_label
		"Updated"
	end

	# RENDER
	# ============================================================
	# PARAGRAPHS
	# ------------------------------------------------------------
	def uploaded_by
		h.content_tag :p, class: 'agents' do
			("Uploaded by " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

	def timestamps
		time = time_started

		unless just_created?
			time += " " + time_updated
		end

		h.content_tag :p, class: 'time' do
			time.html_safe
		end
	end

	# SPAN
	# ------------------------------------------------------------
	def byline
		h.content_tag :span, class: 'byline' do by_uploader end
	end

	def icon
		h.content_tag :span, class: "icon-#{icon_choice} icon" do '' end
	end

	# TABLE DATA
	# ------------------------------------------------------------
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