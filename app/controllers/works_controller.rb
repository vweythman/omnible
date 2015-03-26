class WorksController < ApplicationController
  # GET /works
  # GET /works.json
  def index
    works_search
    @top_appearers = Character.top_appearers
  end

  def curated_index
    @works = @parent.works
    render 'curated_index'
  end

  def character_index
    @parent = Character.find(params[:character_id])
    curated_index
  end

  def concept_index
    @parent = Concept.find(params[:concept_id])
    curated_index
  end

  def identity_index
    @parent = Identity.find(params[:identity_id])
    curated_index
  end

  # GET /works/1
  # GET /works/1.json
  def show
    work_find

    # add if owner render show
    # add if hidden render restricted
    if @work.chapters.length > 0
      # redirect to first chapter
      redirect_to work_chapter_path(@work, @work.chapters.first)
    elsif @work.notes.length > 0
      redirect_to work_notes_path(@work)
    else
      # render resticted
    end
  end

  # GET /works/new
  def new
    @work = Work.new
  end

  # GET /works/1/edit
  def edit
    work_find
  end

  # POST /works
  # POST /works.json
  def create
    @work = Work.new(work_params)

    if @work.save
      redirect_to @work
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    work_find

    if @work.update(work_params)
      redirect_to @work
    else
     render action: 'edit'
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    @work.destroy
    respond_to do |format|
      format.html { redirect_to works_url }
      format.json { head :no_content }
    end
  end

  private
    def work_find
      @work = Work.find(params[:id])
    end

    def works_search
      @works = Work.includes(:user).page(params[:page])
    end

    def work_params
      params.require(:work).permit(:title, :user_id, :summary, 
        appearances_attributes: [:id, :character_id, :role, :_destroy],
        conceptions_attributes: [:id, :concept_id, :_destroy])
    end
end
