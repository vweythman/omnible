class ArticlesDecorator < WorksDecorator

	# MODULES
	# ------------------------------------------------------------
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Articles"
	end

	def klass
		:articles
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count", key: "word-count"}
		filters.except!(:completion)
	end

end
