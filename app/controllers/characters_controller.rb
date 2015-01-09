class CharactersController < ApplicationController
  # HAS ASSOCIATED VIEW
  def index
    @characters = Character.order('name').all
  end

  def show
    @character = Character.find(params[:id])
  end

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
    params.require(:character).permit(:name, :description)
  end
end
