class Works::Journals::ArticlesController < Works::NotesController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	
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
