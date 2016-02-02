class Works::ShortStoriesController < WorksController

	# FILTERS
	# ============================================================
	before_action :short_story, except: [:index, :new, :create]

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def short_story
		@short = @work
	end

	# Works :: find all with filtering
	def works
		@works = ShortStoriesDecorator.decorate(ShortStory.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def new_work
		@work = @short = ShortStory.new.decorate
	end

	# WorkParams :: define strong parameters
	def work_params
		params.require(:short_story).permit(
			:title,        :summary,         :visitor,
			:editor_level, :publicity_level, :placeables,   :taggables,

			uploadership:        [:category, :pen_name],
			appearables:         [:main,     :side,     :mentioned],
			skinning_attributes: [:id,       :skin_id,  :_destroy],
			rating_attributes:   [:id,       :violence, :sexuality, :language],
			chapter_attributes:  [:id,       :title,    :about,     :position, :content, :afterward]
		)
	end

end
