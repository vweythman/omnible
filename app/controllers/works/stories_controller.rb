class Works::StoriesController < WorksController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
		if @work.chapters.length > 0
			redirect_to [@work, @work.chapters.first]
		else
			redirect_to whole_story_path(@work)
		end
	end

	def edit
		@story = @work
	end

	# POST
	# ............................................................
	def create
		@story = Story.new(work_params)
		@story.uploader = current_user

		if @story.save
			redirect_to @story
		else
			begin_work
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		@story = @work
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

	# find all with options from a filter
	def find_works
		@works = Story.with_filters(index_params, current_user)
		@works = StoriesDecorator.decorate(@works)
	end

	# setup work
	def begin_work
		@rate = @story.nil? ? Rating.new   : @story.rating
		@skin = @story.nil? ? Skinning.new : @skin.rating

		@story ||= Story.new
		@story.uploader = current_user
		@story.rating   = @rate
		@story.skinning = @skin

		@story = @story.decorate
		@work  = @story
	end

	# set tag creation
	def setup_tags
		create_tags(:story, true)
	end

	# define strong parameters
	def work_params
		params.require(:story).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
			skinning_attributes:    [:id, :skin_id, :_destroy],
			appearances_attributes: [:id, :character_id, :role],
			taggings_attributes:    [:id, :tag_id],
			settings_attributes:    [:id, :place_id],
			rating_attributes:      [:id, :violence, :sexuality, :language],
			chapters_attributes:    [:id, :title, :about, :position, :content, :afterward]
		)
	end

end
