class FictionDecorator < WorksDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Fiction"
	end

	def local_types
		{
			:stories       => h.stories_path,
			:short_stories => h.short_stories_path
		}
	end

	def external_types
		{ :story_links => h.story_links_path }
	end
	
end
