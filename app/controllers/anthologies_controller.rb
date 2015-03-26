class AnthologiesController < ApplicationController
  def index
    @anthologies = Anthology.order('lower(name)').all
  end

  def show
    @anthology = Anthology.find(params[:id])
    @works     = @anthology.works
  end

  def new
    @anthology = Anthology.new
    @anthology.collections.build
  end

  def edit
    @anthology = Anthology.find(params[:id])

    @anthology.collections.build if @anthology.collections.empty?
  end

  def create
    @anthology = Anthology.new(anthology_params)

    if @anthology.save
      redirect_to @anthology
    else
      render action: 'new'
    end
  end

  def update
    @anthology = Anthology.find(params[:id])

    if @anthology.update(anthology_params)
      redirect_to @anthology
    else
      render action: 'edit'
    end
  end

  def destroy
    @anthology = Anthology.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  private
  def anthology_params
    params.require(:anthology).permit(:name, collections_attributes: [:id, :work_id, :_destroy])
  end
end
