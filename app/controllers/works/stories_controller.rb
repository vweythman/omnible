class Works::StoriesController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		work
		if @story.chapters.length > 0
			redirect_to [@story, @story.chapters.first]
		else
			redirect_to whole_story_path(@story)
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@story = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::StoriesDecorator.decorate(Work.by_type("Story").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @story = Story.new(work_params).decorate
	end

	def new_work
		@work = @story = Story.new.decorate
		@work.rating = Rating.new
	end

	# define strong parameters
	def work_params
		based_permitted = base_work_params(:story)
		story_permitted = params.require(:story).permit(chapters_attributes: [:id, :title, :about, :position, :content, :afterward])
		based_permitted.merge story_permitted
	end

end
