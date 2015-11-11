class StoryLinksDecorator < WorksDecorator

	def title
		"Story Links"
	end

	def creation_path
		h.creation_toolkit "Link", h.new_story_link_path
	end

end
