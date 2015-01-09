class FacetsController < ApplicationController
  # HAS ASSOCIATED VIEW
  def index
    @facets = Facet.order('name').all
  end

  def show
    @facet = Facet.find(params[:id])
    @terms = @facet.terms
  end

  def new
    @facet = Facet.new
  end

  def edit
    @facet = Facet.find(params[:id])
  end

  def delete
    @facet = Facet.find(params[:id])
  end

  # REDIRECTS OR RENDERS AFTER ACTION
  def destroy
    @facet = Facet.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  def create
    @facet = Facet.new(facet_params)

    if @facet.save
      redirect_to @facet
    else
      render 'new'
    end
  end

  def update
    @facet = Facet.find(params[:id])

    if @facet.update(facet_params)
      redirect_to @facet
    else
      render action: 'edit'
    end
  end

  private
  def facet_params
    params.require(:facet).permit(:name)
  end
end
