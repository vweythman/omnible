class StoriesDecorator < WorksDecorator

	def title
		"Stories"
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count",    key: "word-count" }
		filters[:order][:values] << { heading: "Chapter Count", key: "chapter-count" }
		return filters
	end

	def creation_path
		h.creation_toolkit "Story", h.new_story_path
	end

end
