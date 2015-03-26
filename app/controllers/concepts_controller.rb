class ConceptsController < ApplicationController
  def index
  	@concepts = Concept.order('name').all
  end

  def show
  	concept_find
  end

  def new
    @concept = Concept.new
  end

  def edit
  	concept_find
  end

  # post
  def create
    @concept = Concept.new(concept_params)
    if @concept.save
      redirect_to(:action => 'index')
    else
      render action: 'new'
    end
  end

  def update
    concept_find

    if @concept.update(concept_params)
      redirect_to(:action => 'index')
    else
     render action: 'edit'
    end
  end

  # delete one
  def destroy
    @concept = Concept.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  private
  def concept_find
  	@concept = Concept.find(params[:id])
  end

  def concept_params
    params.require(:concept).permit(:name)
  end
end
