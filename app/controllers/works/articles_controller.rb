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
		@works = Collectables::Works::ArticlesDecorator.decorate(Work.by_type("Article").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @article = Article.new(work_params).decorate
	end

	def new_work
		@article         = Article.new
		@article.rating  = Rating.new
		@article.note    = Note.new
		@article = @work = @article.decorate
	end

	# WorkParams :: define strong parameters
	def work_params
		based_permitted = base_work_params(:article)
		based_permitted.merge(:article_content => params[:article][:article_content])
	end

end
