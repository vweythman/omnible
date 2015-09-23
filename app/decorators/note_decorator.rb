class NoteDecorator < EditableDecorator
	delegate_all

	# HEADINGS
	# ------------------------------------------------------------
	def creation_title
		"Create Note"
	end
	
	def editing_title
		meta_title + " (Edit Draft)"
	end

	def heading
		if title.empty?
			"Note"
		else
			title
		end
	end

	def meta_title
		work.title + " - " + heading
	end

	def editor_heading
		link = h.link_to work.title, work
		h.content_tag :h1, class: 'ref' do "Edit Note of #{link}".html_safe end
	end

end
