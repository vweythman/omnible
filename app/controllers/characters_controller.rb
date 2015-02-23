class CharactersController < ApplicationController
  # MANY
  def index
    @characters = Character.order('name').all
  end

  # ONE
  def show
    @character = Character.find(params[:id])
  end

  def preview
    @character = Character.find(params[:id])
  end

  # CHANGE
  def new
    @character = Character.new
  end

  def edit
    @character = Character.find(params[:id])
  end

  def delete
    @character = Character.find(params[:id])
  end

  # REDIRECTS OR RENDERS AFTER ACTION

  def create
    @character = Character.new(character_params)

    if @character.save
      redirect_to @character
    else
      render 'new'
    end
  end

  def update
    @character = Character.find(params[:id])

    if @character.update(character_params)
      redirect_to @character
    else
      render action: 'edit'
    end
  end

  def destroy
    @character = Character.find(params[:id]).destroy
    redirect_to(:action => 'index')
  end

  private
  def character_params
    params.require(:character).permit(:name, :about, 
      descriptions_attributes: [:id, :identity_id, :_destroy], 
      opinions_attributes:     [:id, :recip_id,    :recip_type, :warmth, :respect, :about, :_destroy],
      prejudices_attributes:   [:id, :recip_id,    :recip_type, :warmth, :respect, :about, :_destroy]
      )
  end
end
