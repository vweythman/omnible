class CastsController < ApplicationController
  def index
  	@work  = Work.find(params[:work_id])
  	@casts = @work.casts
  end

  def show
  	@cast = Cast.find(params[:id])
  end

  def new
    @work = Work.find(params[:work_id])
    @cast = Cast.new
    @cast.memberships.build
  end

  def edit
    @work = Work.find(params[:work_id])
    @cast = Cast.find(params[:id])

    @cast.memberships.build if @cast.memberships.empty?
  end

  def create
  	@work = Work.find(params[:work_id])
    @cast = Cast.new(cast_params)

    if @cast.save
      redirect_to [@work, @cast]
    else
      render action: 'new'
    end
  end

  def update
    @cast = Cast.find(params[:id])

    if @cast.update(cast_params)
      redirect_to [@cast.work, @cast]
    else
      render action: 'edit'
    end
  end

  private
    def cast_params
      params.require(:cast).permit(:title, :work_id, :about, memberships_attributes: [:id, :character_id, :role, :_destroy])
    end
end
