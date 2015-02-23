class WorksController < ApplicationController
  # GET /works
  # GET /works.json
  def index
    @works = Work.all
  end

  # GET /works/1
  # GET /works/1.json
  def show
    work_find
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

    def work_params
      params.require(:work).permit(:title, :user_id, :summary, 
        appearances_attributes: [:id, :character_id, :role, :_destroy],
        conceptions_attributes: [:id, :concept_id, :_destroy])
    end
end
