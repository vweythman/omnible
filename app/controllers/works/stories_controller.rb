class Works::StoriesController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		find_comments
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
		@story = @work = Work.find(params[:id]).decorate
	end

	# Works :: find all with filtering
	def works
		@works = StoriesDecorator.decorate(Story.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def new_work
		@work = @story = Story.new.decorate
	end

	# define strong parameters
	def work_params
		params.require(:story).permit(
			:title,        :summary,         :visitor,
			:editor_level, :publicity_level, :placeables,   :taggables,

			uploadership:        [:category, :pen_name],
			appearables:         [:main,     :side,     :mentioned],
			skinning_attributes: [:id,       :skin_id,  :_destroy],
			rating_attributes:   [:id,       :violence, :sexuality, :language],
			chapters_attributes: [:id,       :title,    :about,     :position, :content, :afterward]
		)
	end

end