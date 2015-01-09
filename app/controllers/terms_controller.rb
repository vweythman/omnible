class TermsController < ApplicationController
  def index
    @terms = Term.order('lower(name)').all
  end

  def show
    @term = Term.find(params[:id])
  end

  def new
    @term = Term.new
    @broad_edge = @term.broad_edges.build
  end

  def edit
    @term = Term.find(params[:id])
  end

  def delete
    @term = Term.find(params[:id])
  end

  def destroy
    @term = Term.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  def create
    @term  = Term.new(term_params)

    if @term.save
      redirect_to @term
    else
      render action: 'new'
    end
  end

  def update
    @term = Term.find(params[:id])

    if @term.update(term_params)
      redirect_to @term
    else
      render action: 'edit'
    end
  end

  private

  def term_params
    params.require(:term).permit(:name, :facet_id, :broad_edges_ids => [])
  end

end
