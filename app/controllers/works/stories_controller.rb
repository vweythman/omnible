class Works::StoriesController < WorksController
  def index
  end

  def show
		find_work

		if !@work.viewable? current_user
			render 'restrict'
		elsif @work.chapters.count > 0
			redirect_to [@work, @work.chapters.first]
		end
  end

  def new
  end

  def edit
  end

end
