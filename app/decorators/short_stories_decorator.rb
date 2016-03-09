class ShortStoriesDecorator < FictionDecorator

	# MODULES
	# ------------------------------------------------------------
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Short Stories"
	end

	def klass
		:short_stories
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count",    key: "word-count" }
		filters.except!(:completion)
	end

end
