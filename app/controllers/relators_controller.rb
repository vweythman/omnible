class RelatorsController < ApplicationController
  def index
  	@relators = Relator.order('left_name').all
  end

  def show
  	relator_find
  end

  def new
  	@relator = Relator.new
  end

  def edit
  	relator_find
  end

  def create
    @relator = Relator.new(relator_params)
    if @relator.save
      redirect_to @relator
    else
      render action: 'new'
    end
  end

  def update
  	relator_find

    if @relator.update(relator_params)
      redirect_to @relator
    else
     render action: 'edit'
    end
  end

  private
  def relator_find
  	@relator = Relator.find(params[:id])
  end

  def relator_params
  	params.require(:relator).permit(:right_name, :left_name, relationships_attributes: [:id, :left_id, :right_id, :_destroy])
  end
end
