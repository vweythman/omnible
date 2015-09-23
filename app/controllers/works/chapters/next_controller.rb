class Works::Chapters::NextController < Works::ChaptersController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# POST
	# ............................................................
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
	# ------------------------------------------------------------
	private
	def find_viewable_story
		@previous = Chapter.find(params[:chapter_id])
		@story    = @previous.story
		unless @story.viewable? current_user
			render 'works/restrict'
		end
	end

end
