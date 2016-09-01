class Works::WholeStoryController < Works::StoriesController

	def show
		work
		@chapters = Collectables::Works::ChaptersDecorator.decorate @story.chapters.ordered
		find_comments
	end

end
