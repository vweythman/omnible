class TermEdgesController < ApplicationController
  def index
    @term_edges = TermEdge.all
  end

  def show
    @term_edge = TermEdge.find(params[:id])
  end

  def new
    @term_edge = TermEdge.new
  end

  def edit
    @term_edge = TermEdge.find(params[:id])
  end

  def delete
    @term_edge = TermEdge.find(params[:id])
  end


  def create
    @term_edge  = TermEdge.new(term_edge_params)

    if @term_edge.save
      redirect_to @term_edge
    else
      render action: 'new'
    end
  end

  def update
    @term_edge = TermEdge.find(params[:id])

    if @term_edge.update(term_edge_params)
      redirect_to @term_edge
    else
      render action: 'edit'
    end
  end

  def destroy
    @term_edge = TermEdge.find(params[:id])
    redirect_to(:action => 'index')
  end

  private

  def term_edge_params
    params.require(:term_edge).permit(:broad_term_id, :narrow_term_id)
  end


end
