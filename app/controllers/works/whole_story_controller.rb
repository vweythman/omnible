class Works::WholeStoryController < Works::StoriesController

	def show
		@story    = @work
		@chapters = @story.chapters.decorate
		find_comments
	end

end
