class NonfictionDecorator < WorksDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Nonfiction"
	end

	def local_types
		{
			:articles => h.articles_path
		}
	end

	def external_types
		{}
	end

end
