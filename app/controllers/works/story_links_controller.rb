class Works::StoryLinksController < WorksController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_link, only: [:update]

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

	# POST
	# ............................................................
	def create
		@link = StoryLink.new(work_params)
		@link.uploader = current_user

		if @link.save
			redirect_to @link
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

	# find all with options from a filter
	def find_works
		@works = StoryLink.with_filters(index_params, current_user)
		@works = StoryLinksDecorator.decorate(@works)
	end

	def find_link
		@work = StoryLink.find(params[:id]).decorate
	end

	def begin_work
		@link ||= StoryLink.new
		@link.sources.build
		@link  = @link.decorate
		@work  = @link
	end

	# set tag creation
	def setup_tags
		create_tags(:story_link, true)
	end

	# define strong parameters
	def work_params
		params.require(:story_link).permit(:title, 
			appearances_attributes: [:id, :character_id, :role],
			taggings_attributes:    [:id, :tag_id],
			settings_attributes:    [:id, :place_id],
			sources_attributes:     [:id, :reference]
		)
	end

end
