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
		@short  = ShortStory.new(work_params)
		content = params[:short_story][:content]

		if @short.save && @short.update_content(content)
			redirect_to @short
		else
			begin_work
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		content = params[:short_story][:content]
		update_tags(@work)
		if @work.update(work_params) && @work.update_content(content)
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

	# switch to work params
	def story_to_work_params
		params[:work] = params[:short_story]
	end

end
