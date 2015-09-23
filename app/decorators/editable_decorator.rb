class EditableDecorator < Draper::Decorator

	# HEADINGS
	# ------------------------------------------------------------
	def started_label
		"Uploaded"
	end

	def most_recent_label
		"Updated"
	end


	# ABOUT
	# ------------------------------------------------------------
	def uploaded_by
		h.content_tag :p, class: 'agents' do
			("Uploaded by " + h.link_to(uploader.name, uploader)).html_safe
		end
	end

	def timestamps
		time = started_label + ": " + h.timestamp(created_at).html_safe
		unless just_created?
			time = time + " | " + most_recent_label  + ": " + h.timestamp(updated_at).html_safe
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

	# EDITING
	# ------------------------------------------------------------
	def edit_bar
		if h.user_signed_in?
			h.content_tag :nav, class: 'toolkit alteration' do
				h.concat link_to_editing
				h.concat link_to_deleting
			end
		end
	end

	def link_to_editing
		h.link_to 'Edit', h.edit_polymorphic_path(object)
	end

	def link_to_deleting
		h.link_to 'Delete', object, method: :delete, data: { confirm: "Are you sure you want to delete #{model.heading}?" }
	end

end
