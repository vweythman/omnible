class FictionDecorator < WorksDecorator

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
		{ :story_records => h.story_records_path }
	end
	
end
