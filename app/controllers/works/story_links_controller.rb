class Works::StoryLinksController < WorksController

	# FILTERS
	# ============================================================
	before_action :story_link,   only: [:edit, :update, :show]
	before_action :link_sources, only: [:edit, :update, :create]

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def story_link
		@link = @work
	end

	# Works :: find all with filtering
	def works
		@works = StoryLinksDecorator.decorate(StoryLink.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def new_work
		@work = @link = StoryLink.new.decorate
		link_sources
	end

	def link_sources
		@link.sources.build
	end

	# WorkParams :: define strong parameters
	def work_params
		params.require(:story_link).permit(
			:title, :visitor, :editor_level, :publicity_level, :placeables, :taggables,

			sources_attributes:  [:id,   :reference],
			appearables:         [:main, :side,     :mentioned],
			skinning_attributes: [:id,   :skin_id,  :_destroy],
			rating_attributes:   [:id,   :violence, :sexuality, :language]
		)
	end

end