class CharactersController < ApplicationController
	# MODULES
	# ------------------------------------------------------------
	include Curated

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@characters = Character.order('name').all
	end

	def curated_index
		@characters = @parent.characters
		render 'curated_index'
	end

	def show
		find_character
		@identities    = Identity.organize(@character.identities.includes(:facet))
		@relationships = @character.relationships
	end

	def preview
		find_character
	end

	def new
		@character = Character.new
		@character.descriptions.build
	end

	def edit
		find_character
	end

	# POST
	# ............................................................
	def create
		@character = Character.new(character_params)

		if @character.save
			redirect_to @character
		else
			render 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_character

		if @character.update(character_params)
			redirect_to @character
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@character = Character.find(params[:id]).destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_character
		@character = Character.find(params[:id])
	end

	# define strong parameters
	def character_params
		params.require(:character).permit(:name, :about, 
			identifiers_attributes:  [:id, :name,        :_destroy],
			descriptions_attributes: [:id, :identity_id, :_destroy],
			opinions_attributes:     [:id, :recip_id,    :recip_type, :warmth, :respect, :about, :_destroy],
			prejudices_attributes:   [:id, :recip_id,    :recip_type, :warmth, :respect, :about, :_destroy]
		)
	end

end
