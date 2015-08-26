class Works::ShortStoriesController < WorksController
	def index
	end

	def show
		@short    = ShortStory.find(params[:id])

		# about short stories
		@rating   = @short.rating
		@comments = @short.comments
		@comment  = Comment.new

		@comment.topic = @short.topic
	end

	def new
	end

	def edit
	end
end
