class Works::ShortStoriesController < WorksController

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# WorkParams :: define strong parameters
	def work_params
		based_permitted = base_work_params(:short_story)
		based_permitted.merge(:story_content => params[:short_story][:story_content])
	end

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@short = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::Works::ShortStoriesDecorator.decorate(Work.by_type("ShortStory").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @short = ShortStory.new(work_params).decorate
	end

	def new_work
		@work = @short = ShortStory.new.decorate
		@work.rating = Rating.new
	end

end
