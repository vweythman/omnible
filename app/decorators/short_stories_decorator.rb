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
		h.creation_toolkit "Short Story", :short_story
	end

end
