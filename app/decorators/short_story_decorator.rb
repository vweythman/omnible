class ShortStoryDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Short Story"
	end

	def klass
		@klass ||= :short_story
	end

	def link_to_self
		h.link_to "Story", h.short_story_path(self)
	end

	def most_recent_label
		"Changed"
	end

	def createables_links
		if self.editable?(h.current_user)
			h.prechecked_createables [[self, :note]]
		end
	end

	def icon_choice
		'file-text'
	end

	# -- Navigation
	# ............................................................
	def navigation_on_short
		h.content_tag :p, class: "related-menu" do
			link_to_notes
		end
	end
	
	def navigation_on_note
		h.content_tag :p, class: "related-menu" do
			(link_to_self + " | " + link_to_notes).html_safe
		end
	end

	# -- Related
	# ............................................................
	def link_to_notes
		if self.notes.length > 0
			h.link_to "Notes", h.short_story_notes_path(self)
		end
	end

end
