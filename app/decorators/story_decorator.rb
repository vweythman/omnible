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
			h.prechecked_creation_toolkit("Chapter", [self, :chapter])
		end
	end

	def chapter_insertion_link
		if self.editable?(h.current_user)
			h.insertion_toolkit("Chapter", [self, :chapter])
		end
	end

	def current_chapters
		self.chapters.build if self.chapters.length == 0
		@current_chapters ||= ChaptersDecorator.decorate(self.chapters)
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
