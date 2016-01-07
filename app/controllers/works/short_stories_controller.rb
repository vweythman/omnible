class Works::ShortStoriesController < WorksController

	# FILTERS
	# ------------------------------------------------------------
	before_action :story_to_work_params, only: [:create, :update]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
		@short = @work
		find_comments
	end

	def edit
		@short = @work
	end

	# POST
	# ............................................................
	def create
		@short = ShortStory.new(work_params)
		@short.uploader = current_user

		if @short.save
			redirect_to @short
		else
			begin_work
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		update_tags(@work)
		if @work.update(work_params)
			redirect_to @work
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# FOR NEW :: setup work
	def begin_work
		@short ||= ShortStory.new
		@short = @short.decorate
		@work  = @short
		@work.rating ||= Rating.new
	end

	# find all with options from a filter
	def find_works
		@works = ShortStory.with_filters(index_params, current_user)
		@works = ShortStoriesDecorator.decorate(@works)
	end

	# set tag creation
	def setup_tags
		create_tags(:short_story, true)
	end

	def work_params
		params.require(:short_story).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
			skinning_attributes:    [:id, :skin_id, :_destroy],
			appearances_attributes: [:id, :character_id, :role],
			taggings_attributes:    [:id, :tag_id],
			settings_attributes:    [:id, :place_id],
			rating_attributes:      [:id, :violence, :sexuality, :language],
			chapter_attributes:     [:id, :title, :about, :position, :content, :afterward]
		)
	end

end
