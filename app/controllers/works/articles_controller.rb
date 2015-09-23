class Works::ArticlesController < WorksController
	
	# FILTERS
	# ------------------------------------------------------------
	before_action :article_to_work_params, only: [:create, :update]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
		@article = @work
		find_comments
	end

	def edit
		@article = @work
	end

	# POST
	# ............................................................
	def create
		@article = Article.new(work_params)
		content  = params[:article][:content]

		if @article.save && @article.update_content(content)
			redirect_to @article
		else
			begin_work
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		content = params[:article][:content]

		if @work.update(work_params) && @work.update_content(content)
			redirect_to @work
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all with options from a filter
	def find_works
		@works = Article.with_filters(index_params, current_user)
		@works = ArticlesDecorator.decorate(@works)
	end

	# setup work
	def begin_work
		@article = Article.new
		@note    = Note.new

		@article.note = @note
		@article = @article.decorate
		@work    = @article
	end

	def article_to_work_params
		params[:work] = params[:article]
	end

end
