class FictionDecorator < WorksDecorator

	def title
		"Fiction"
	end

	def local_types
		[:stories, :short_stories]
	end

	def external_types
		[:story_records]
	end
end
