class ChaptersController < ApplicationController
  def index
  	@work     = Work.find(params[:work_id])
  	@chapters = @work.chapters
  end

  def show
    chapter_find
  end

  def new
    @work    = Work.find(params[:work_id])
    @chapter = Chapter.new
  end

  def edit
    chapter_find
  end

  def create
  	@work    = Work.find(params[:work_id])
    @chapter = Chapter.new(chapter_params)

    if @chapter.save
      redirect_to [@work, @chapter]
    else
      render action: 'new'
    end
  end

  def update
    @chapter = Chapter.find(params[:id])

    if @chapter.update(chapter_params)
      redirect_to [@chapter.work, @chapter]
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  private
    def chapter_find
      @chapter = Chapter.find(params[:id])
      @work    = @chapter.work
    end

    def chapter_params
      params.require(:chapter).permit(:title, :work_id, :about, :position, :content, :afterward)
    end
end
