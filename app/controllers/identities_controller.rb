class IdentitiesController < ApplicationController
  def index
  	@identities = Identity.organized_all
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
    @facet    = Facet.where(name: params[:identity][:facet_name]).first_or_create
    @identity = Identity.new(identity_params)

    @identity.facet_id = @facet.id
    if @identity.save
      redirect_to(:action => 'index')
    else
      render action: 'new'
    end
  end

  def update
    @identity = Identity.find(params[:id])
    @facet    = Facet.where(name: params[:identity][:facet_name]).first_or_create

    params[:identity][:facet_id] = @facet.id
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
    params.require(:identity).permit(:name, :facet_id, descriptions_attributes: [:id, :character_id, :_destroy])
  end
end
