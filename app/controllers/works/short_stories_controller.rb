class Works::ShortStoriesController < WorksController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
		@short = @work
		find_comments
	end

	def new
	end

	def edit
		@short = @work
	end

	# PATCH/PUT
	# ............................................................
	def update
		content = params[:short_story][:content]

		if @work.update(work_params) && @work.update_content(content)
			redirect_to @work
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all with options from a filter
	def find_works
		@works = ShortStory.with_filters(index_params, current_user)
		@works = ShortStoriesDecorator.decorate(@works)
	end

	def work_params
	params.require(:short_story).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
		appearances_attributes: [:id, :character_id, :role, :_destroy],
		rating_attributes:      [:id, :violence, :sexuality, :language]
	)
	end
end
