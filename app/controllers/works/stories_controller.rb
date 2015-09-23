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
		set_chapters
	end

	# POST
	# ............................................................
	def create
		@story = Story.new(work_params)

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
		@story = Story.new
		@story = @story.decorate
		@work  = @story
		build_chapters
	end

	def build_chapters
		@work.chapters.build
		set_chapters
	end

	def set_chapters
		@chapters = ChaptersDecorator.decorate(@work.chapters)
	end

	# define strong parameters
	def work_params
		params.require(:story).permit(:title, :uploader_id, :summary, :publicity_level, :editor_level, 
			appearances_attributes: [:id, :character_id, :role, :_destroy],
			rating_attributes:      [:id, :violence, :sexuality, :language],
			chapters_attributes:    [:id, :title, :about, :position, :content, :afterward]
		)
	end

end
