class Works::Chapters::NextController < Works::ChaptersController

	# PUBLIC METHODS
	# ============================================================
	# POST
	# ------------------------------------------------------------
	def create
		previous_chapter
		story
		cannot_edit? @story do
			return
		end

		@chapter = @story.chapters.new(chapter_params)

		Chapter.transaction do
			@chapter.place_after @previous
			
			if @chapter.save
				redirect_to [@story, @chapter]
			else
				@chapter = @chapter.decorate
				render action: 'new'
			end
		end
	end

	def new
		previous_chapter
		story
		cannot_edit? @story do
			return
		end
		@chapter = Chapter.new.decorate
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def previous_chapter
		@previous = Chapter.find(params[:chapter_id])
	end

	def story
		@story = @previous.story
	end

end
