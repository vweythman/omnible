class ArticleDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	def creation_title
		"Create Article"
	end

	def klass
		:article
	end

	def most_recent_label
		"Changed"
	end
	
	def icon
		"◧"
	end
	
end
