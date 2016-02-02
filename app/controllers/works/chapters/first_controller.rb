class Works::Chapters::FirstController < Works::ChaptersController

	# PUBLIC METHODS
	# ============================================================
	def create
		@chapter = Chapter.new(chapter_params)

		Chapter.transaction do
			@chapter.place_first

			if @chapter.save
				redirect_to [@story, @chapter]
			else
				render action: 'new'
			end
		end
	end

end
