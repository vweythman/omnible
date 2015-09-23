class ShortStoriesDecorator < WorksDecorator

	def title
		"Short Stories"
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count",    key: "word-count" }
		return filters
	end

	def creation_path
		h.index_toolkit "Short Story", h.new_short_story_path
	end

end