class StoriesDecorator < FictionDecorator

	# MODULES
	# ------------------------------------------------------------
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def klass
		:stories
	end

	def title
		"Stories"
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count",    key: "word-count" }
		filters[:order][:values] << { heading: "Chapter Count", key: "chapter-count" }
		return filters
	end

end
