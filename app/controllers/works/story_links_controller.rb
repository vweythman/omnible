class Works::StoryLinksController < WorksController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
		@link = @work
		find_comments
	end

	def edit
		@link = @work
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all with options from a filter
	def find_works
		@works = StoryLink.with_filters(index_params, current_user)
		@works = StoryLinksDecorator.decorate(@works)
	end

	# set tag creation
	def setup_tags
		create_tags(:story_link, true)
	end

	# define strong parameters
	def work_params
		params.require(:story_link).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
			appearances_attributes: [:id, :character_id, :role, :_destroy],
			settings_attributes:    [:id, :place_id, :_destroy]
		)
	end

end
