class Works::ComicsController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		work
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	# Work :: find by id
	def work
		super
		@art = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::Works::ComicsDecorator.decorate(Work.by_type("Comic").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @art = Comic.new(work_params).decorate
	end

	def new_work
		@work = @art = Comic.new.decorate
		@art.pages.build
		@work.rating = Rating.new
	end

	# define strong parameters
	def work_params
		based_permitted = base_work_params(:comic)
		art_permitted   = params.require(:comic).permit(pages_attributes: [:id, :title, :artwork, :description])
		based_permitted.merge art_permitted
	end

end
