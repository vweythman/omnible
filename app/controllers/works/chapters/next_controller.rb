class Works::Chapters::NextController < Works::ChaptersController

	# FILTERS
	# ============================================================
	before_action :previous_chapter, only: [:create]

	# PUBLIC METHODS
	# ============================================================
	# POST
	# ------------------------------------------------------------
	def create
		@chapter = Chapter.new(chapter_params)

		Chapter.transaction do
			@chapter.place_after @previous
			
			if @chapter.save
				redirect_to [@work, @chapter]
			else
				render action: 'new'
			end
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private
	
	def previous_chapter
		@previous = Chapter.find(params[:chapter_id])
	end

end
