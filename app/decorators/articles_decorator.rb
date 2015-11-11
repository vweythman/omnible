class ArticlesDecorator < WorksDecorator

	def title
		"Articles"
	end

	def filter_values
		filters = super
		filters[:order][:values] << { heading: "Word Count", key: "word-count"}
		return filters
	end

	def creation_path
		h.creation_toolkit "Article", h.new_article_path
	end

end
