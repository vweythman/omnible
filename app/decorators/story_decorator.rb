class StoryDecorator < WorkDecorator

	def creation_title
		"Create Story"
	end

	# CHAPTERS
	# ------------------------------------------------------------
	def link_to_chapters
		h.link_to "Chapters", h.story_chapters_path(self)
	end

	def chapter_creation_link
		if self.editable?(h.current_user)
			h.insertion_link("Add Chapter", h.new_story_chapter_path(self))
		end
	end

	def chapter_insertion_link
		if self.editable?(h.current_user)
			h.insertion_link("+ New Chapter Here", h.new_story_chapter_path(self))
		end
	end

	# NOTES
	# ------------------------------------------------------------
	def link_to_notes
		h.link_to "Notes", h.story_notes_path(self)
	end

	def note_creation_link
		if self.editable?(h.current_user)
			h.insertion_link("Add Note", h.new_story_note_path(self))
		end
	end

	def note_insertion_link
		if self.editable?(h.current_user)
			h.insertion_link("+ New Note Here", h.new_story_note_path(self))
		end
	end

	# NAVIGATION
	# ------------------------------------------------------------
	def component_indices
		indices = link_to_chapters

		if self.notes.length > 0
			indices = indices + " | " + link_to_notes
		end

		h.content_tag :p do
			indices.html_safe
		end
	end

end
