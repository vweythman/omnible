class IdentitiesController < ApplicationController
  def index
  	@identities = Identity.order('name').all
    @faceted_identities = Identity.organize(@identities)
  end

  def show
  	@identity = Identity.find(params[:id])
  end

  def new
    @identity = Identity.new
  end

  def edit
  	@identity = Identity.find(params[:id])
  end

  # post
  def create
    @identity = Identity.new(identity_params)
    if @identity.save
      redirect_to(:action => 'index')
    else
      render action: 'new'
    end
  end

  def update
    @identity = Identity.find(params[:id])

    if @identity.update(identity_params)
      redirect_to(:action => 'index')
    else
     render action: 'edit'
    end
  end

  # delete one
  def destroy
    @identity = Identity.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  private
  def identity_params
    params.require(:identity).permit(:name, :facet, descriptions_attributes: [:id, :character_id, :_destroy])
  end
end
