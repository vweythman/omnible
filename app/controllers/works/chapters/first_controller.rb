class Works::Chapters::FirstController < Works::ChaptersController

	# PUBLIC METHODS
	# ============================================================
	def create
		@story = Story.find(params[:story_id]).decorate
		cannot_edit? @story do
			return
		end

		@chapter = @story.chapters.new(chapter_params)

		Chapter.transaction do
			@chapter.place_first

			if @chapter.save
				redirect_to [@story, @chapter]
			else
				@chapter = @chapter.decorate
				render action: 'new'
			end
		end
	end

end
