class Subjects::CharactersController < ApplicationController

	# MODULES
	# ------------------------------------------------------------
	include Curated
	include Tagged

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@characters = Character.viewable_for(current_user).order('name')
	end

	def curated_index
		@characters = @parent.characters
		render 'curated_index'
	end

	def show
		find_character
		@identities  = Identity.organize(@character.identities.alphabetic.includes(:facet))
		@items       = Item.organize(@character.items.includes(:generic))
		@connections = @character.ordered_connections
		@viewpoints  = @character.viewpoints
		@prev = @character.prev_character current_user
		@next = @character.next_character current_user
	end

	def preview
		find_character
	end

	def new
		@character = Character.new
		define_components

		@character.opinions.build
		@character.prejudices.build
		@character.possessions.build
	end

	def edit
		find_character
		define_components
	end

	# POST
	# ............................................................
	def create
		set_identifiers
		@character = Character.new(character_params)
		@character.uploader = current_user

		if @character.save
			redirect_to @character
		else
			define_components
			render 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_character
		update_identifiers

		if @character.update(character_params)
			redirect_to @character
		else
			define_components
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
		params.require(:character).permit(:name, :about, :editor_level, :publicity_level, 
			identifiers_attributes:  [:id, :name,        :_destroy],
			descriptions_attributes: [:id, :identity_id, :_destroy],
			possessions_attributes:  [:id, :item_id,     :_destroy],
			opinions_attributes:     [:id, :recip_id,    :fondness, :respect, :about, :_destroy],
			prejudices_attributes:   [:id, :identity_id, :fondness, :respect, :about, :_destroy]
		)
	end

	def set_identifiers
		list = params[:identifiers]
		params[:character][:identifiers_attributes] = build_tags(list.split(";"), :name)
	end

	def update_identifiers
		list    = params[:identifiers]
		list    = list.split(";")
		if list.length > 0
			remove  = Identifier.not_among_for(@character.id, list).destroy_all
			current = Identifier.are_among_for(@character.id, list).pluck(:name)
			params[:character][:identifiers_attributes] = build_tags(list - current, :name)
		else
			@character.identifiers.destroy_all
		end
	end

	# setup form components
	def define_components
		@facets     = Facet.all.includes(:identities)
		@generics   = Generic.all.includes(:items)

		@identities = @facets.collect{|facet|facet.identities}.flatten
		@items      = @generics.collect{|genric|genric.items}.flatten
		@variants   = @character.identifiers.pluck(:name)

		@character.descriptions.build if @character.descriptions.length < 1

		@descnest = Nest.new("Descriptors", :descriptions, "subjects/characters/nested/description_fields")
		@opinnest = Nest.new("Opinions About Other Characters", :opinions, "subjects/characters/nested/opinion_fields")
		@itemnest = Nest.new("Related Items", :possessions, "subjects/characters/nested/possession_fields")
		@prejnest = Nest.new("Personal Prejudices", :prejudices, "subjects/characters/nested/prejudice_fields")
	end
end
