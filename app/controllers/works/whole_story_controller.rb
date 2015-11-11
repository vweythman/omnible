class Works::WholeStoryController < Works::StoriesController

	def show
		@story    = @work
		@chapters = @story.chapters.ordered.decorate
		find_comments
	end

end
