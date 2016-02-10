class Works::ArticlesController < WorksController

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@article = @work
	end

	# Works :: find all with filtering
	def works
		@works = ArticlesDecorator.decorate(Article.with_filters(index_params, current_user))
	end

	def created_work
		@work = Article.new(work_params).decorate
	end

	# SET
	# ------------------------------------------------------------
	def new_work
		@article         = Article.new
		@article.rating  = Rating.new
		@article.note    = Note.new
		@article = @work = @article.decorate
	end

	# WorkParams :: define strong parameters
	def work_params
		puts
		puts params.keys
		puts
		params.require(:article).permit(
			:title,        :summary,         :visitor,
			:editor_level, :publicity_level, :placeables, :taggables,

			appearables:         [:subject],
			uploadership:        [:category, :pen_name],
			note_attributes:     [:id,       :title,   :content],
			skinning_attributes: [:id,       :skin_id, :_destroy]
		)
	end

end
