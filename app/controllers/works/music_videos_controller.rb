class Works::MusicVideosController < WorksController

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
		@video = @work
	end

	# Works :: find all with filtering
	def works
		@works = Collectables::Works::MusicVideosDecorator.decorate(Work.by_type("MusicVideo").with_filters(index_params, current_user))
	end

	# SET
	# ------------------------------------------------------------
	def created_work
		@work = @video = MusicVideo.new(work_params).decorate
	end

	def new_work
		@work = @video = MusicVideo.new.decorate
		@video.embedded_link  = Source.new
	end

	# define strong parameters
	def work_params
		based_permitted = base_work_params(:music_video)
		type_permitted  = params.require(:music_video).permit(embedded_link_attributes: [:id, :reference])
		based_permitted.merge type_permitted
	end

end
