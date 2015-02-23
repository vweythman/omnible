class NotesController < ApplicationController
  def index
  	@work  = Work.find(params[:work_id])
  	@notes = @work.notes
  end

  def show
    @note = Note.find(params[:id])
    @work = @note.work
  end

  def new
    @work = Work.find(params[:work_id])
    @note = Note.new
  end

  def edit
  	@note = Note.find(params[:id])
  	@work = @note.work
  end

  def create
  	@work = Work.find(params[:work_id])
    @note = Note.new(note_params)

    if @note.save
      redirect_to [@work, @note]
    else
      render action: 'new'
    end
  end

  def update
    @note = Note.find(params[:id])

    if @note.update(note_params)
      redirect_to [@note.work, @note]
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  private 
  def note_params
      params.require(:note).permit(:title, :work_id, :content)
  end
end
