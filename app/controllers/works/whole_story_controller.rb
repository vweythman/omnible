class Works::WholeStoryController < Works::StoriesController

	def show
		@chapters = @story.chapters.ordered.decorate
		find_comments
	end

end