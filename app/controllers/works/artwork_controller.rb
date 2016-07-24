class Works::ArtworkController < WorksController

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
		@works = Collectables::ArtworkDecorator.decorate(Art.with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @art = Art.new(work_params).decorate
	end

	def new_work
		@work = @art = Art.new.decorate
		@art.picture = Picture.new
		@work.rating = Rating.new
	end

	# define strong parameters
	def work_params
		based_permitted = base_work_params(:art)
		art_permitted   = params.require(:art).permit(picture_attributes: [:id, :title, :artwork, :description])
		based_permitted.merge art_permitted
	end

end
