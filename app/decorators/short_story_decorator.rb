class ShortStoryDecorator < WorkDecorator

	def creation_title
		"Create Short Story"
	end

	def most_recent_label
		"Changed"
	end

	def link_to_notes
		if self.notes.length > 0
			h.link_to "Story Notes", short_story_notes_path(self)
		end
	end

	def component_indices
		h.content_tag :p do
			link_to_notes
		end
	end

end
