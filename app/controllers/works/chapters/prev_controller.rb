class Works::Chapters::PrevController < Works::ChaptersController

	# PUBLIC METHODS
	# ============================================================
	# POST
	# ------------------------------------------------------------
	def create
		next_chapter
		story
		cannot_edit? @story do
			return
		end

		@chapter = @story.chapters.new(chapter_params)

		Chapter.transaction do
			@chapter.place_before @next
			
			if @chapter.save
				redirect_to [@story, @chapter]
			else
				@chapter = @chapter.decorate
				render action: 'new'
			end
		end
	end

	def new
		next_chapter
		story
		cannot_edit? @story do
			return
		end
		@chapter = Chapter.new.decorate
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def next_chapter
		@next = Chapter.find(params[:chapter_id])
	end

	def story
		@story = @next.story
	end

end
