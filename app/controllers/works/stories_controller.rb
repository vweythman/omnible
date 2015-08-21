class Works::StoriesController < WorksController
  def index
  end

  def show
		find_work

		if @work.viewable?(current_user)

			#redirect_to @work
		#elsif @work.upcoming?
			render 'upcoming'
		else
			render 'restrict'
		end
=begin

		if user_signed_in? && @work.editable?(current_user)
	if @work.chapters.length > 0
		# redirect to first chapter
		redirect_to work_chapter_path(@work, @work.chapters.first)




		
		elsif @work.notes.length > 0
			# redirect to notes index
			redirect_to work_notes_path(@work)
=end
  end

  def new
  end

  def edit
  end
end
