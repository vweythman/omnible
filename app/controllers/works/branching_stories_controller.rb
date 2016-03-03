class Works::BranchingStoriesController < WorksController

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
		@works = WorksDecorator.decorate(BranchingStory.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @story = BranchingStory.new(work_params).decorate
	end

	def new_work
		@story         = BranchingStory.new
		@story.rating  = Rating.new
		@story = @work = @story.decorate
	end

	# WorkParams :: define strong parameters
	def work_params
		params.require(:branching_story).permit(
			:title,        :summary,         :visitor,
			:editor_level, :publicity_level, :placeables,   :taggables,

			uploadership:        [:category, :pen_name],
			appearables:         [:main,     :side,     :mentioned],
			skinning_attributes: [:id,       :skin_id,  :_destroy],
			rating_attributes:   [:id,       :violence, :sexuality, :language],
			branches_attributes: [:id,       :title,    :content]
		)
	end

end
