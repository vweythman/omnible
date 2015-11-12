class StoryLinksDecorator < WorksDecorator

	def title
		"Story Links"
	end

	def creation_path
		h.creation_toolkit "Link", :story_link
	end

end
