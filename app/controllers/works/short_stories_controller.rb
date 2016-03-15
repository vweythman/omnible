class Works::ShortStoriesController < WorksController

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	# WorkParams :: define strong parameters
	def work_params
		params.require(:short_story).permit(
			:title,        :story_content,   :summary,
			:editor_level, :publicity_level, :placeables,   :taggables,

			uploadership:        [:category, :pen_name],
			appearables:         [:main,     :side,     :mentioned],
			skinning_attributes: [:id,       :skin_id,  :_destroy],
			rating_attributes:   [:id,       :violence, :sexuality, :language],
			relateables:         [:main,     :setting,  :mentioned, :characters],
		)
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
		@works = ShortStoriesDecorator.decorate(ShortStory.with_filters(index_params, current_user))
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
