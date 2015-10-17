class Subjects::CharactersController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_viewable_character,  only: [:show]
	before_action :begin_character,          only: [:new]
	before_action :create_tags,              only: [:create]
	before_action :find_editable_character,  only: [:edit, :update]

	# MODULES
	# ------------------------------------------------------------
	include IdentityTagged

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@characters = Character.viewable_for(current_user).order('name').decorate
	end

	def show
	end

	def new
	end

	def edit
		set_associations
	end

	# POST
	# ............................................................
	def create
		@character = Character.new(character_params)
		@character.uploader = current_user

		if @character.save
			redirect_to @character
		else
			set_associations
			render 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		update_tags(@character)

		if @character.update(character_params)
			redirect_to @character
		else
			set_associations
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

	# viewable character found by id
	def find_viewable_character
		@character = Character.find(params[:id])

		unless @character.viewable? current_user
			render 'restrict'
		end
		
		@character = @character.decorate
	end

	# editable character found by id
	def find_editable_character
		@character = Character.find(params[:id])

		unless @character.editable? current_user
			redirect_to @character
		end

		@character = @character.decorate
	end

	# define strong parameters
	def character_params
		params.require(:character).permit(:name, :about, :editor_level, :publicity_level, 
			identifiers_attributes:  [:id, :name,        :_destroy],
			descriptions_attributes: [:id, :identity_id, :_destroy],
			possessions_attributes:  [:id, :item_id, :nature, :_destroy],
			opinions_attributes:     [:id, :recip_id,    :fondness, :respect, :about, :_destroy],
			prejudices_attributes:   [:id, :identity_id, :fondness, :respect, :about, :_destroy]
		)
	end

	def begin_character
		@character = Character.new.decorate
		@character.descriptions.build
		@character.possessions.build
		@character.opinions.build
		@character.prejudices.build
		set_associations
	end

	def set_associations
		@identities = IdentitiesDecorator.decorate(@character.identities)
		@items      = PossessionsDecorator.decorate(@character.items)
		@opinions   = OpinionsDecorator.decorate(@character.opinions)
		@prejudices = PrejudicesDecorator.decorate(@character.opinions)
	end

end
