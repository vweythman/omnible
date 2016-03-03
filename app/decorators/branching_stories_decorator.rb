class BranchingStoriesDecorator < WorksDecorator

	# MODULES
	# ------------------------------------------------------------
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Branching Stories"
	end

	def klass
		:branching_stories
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count", key: "word-count"}
		return filters
	end

end
