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
		@characters = Character.order('name').all
	end

	def curated_index
		@characters = @parent.characters
		render 'curated_index'
	end

	def show
		find_character
		@identities    = Identity.organize(@character.identities.includes(:facet))
		@items         = Item.organize(@character.items.includes(:generic))
		@relationships = @character.relationships.includes(:relator).includes(:left).includes(:right)
		@prejudices    = @character.prejudices.includes(:recip)
		@opinions      = @character.opinions.includes(:recip)
		@viewpoints    = @character.viewpoints
	end

	def preview
		find_character
	end

	def new
		define_components

		@character = Character.new
		@variants  = Array.new

		@character.descriptions.build
		@character.opinions.build
		@character.prejudices.build
		@character.possessions.build
	end

	def edit
		find_character
		define_components
		@variants = @character.identifiers.pluck(:name)
		@character.descriptions.build if @character.descriptions.length < 1
	end

	# POST
	# ............................................................
	def create
		set_identifiers
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
		update_identifiers

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
			possessions_attributes:  [:id, :item_id,     :_destroy],
			opinions_attributes:     [:id, :recip_id,    :recip_type, :warmth, :respect, :about, :_destroy],
			prejudices_attributes:   [:id, :recip_id,    :recip_type, :warmth, :respect, :about, :_destroy]
		)
	end

	def set_identifiers
		list    = params[:identifiers]
		list    = list.split(";")
		params[:character][:identifiers_attributes] = build_tag_list(list, :name)
	end		

	def update_identifiers
		list    = params[:identifiers]
		list    = list.split(";")
		remove  = Identifier.not_among(@character.id, list).destroy_all
		current = Identifier.are_among(@character.id, list).pluck(:name)
		list    = list - current
		params[:character][:identifiers_attributes] = build_tag_list(list, :name)
	end

	# setup form components
	def define_components
		@facets     = Facet.all.includes(:identities)
		@generics   = Generic.all.includes(:items)

		@identities = @facets.collect{|facet|facet.identities}.flatten
		@items      = @generics.collect{|genric|genric.items}.flatten

		@descnest = Nest.new("Descriptors", :descriptions, "subjects/characters/nested/description_fields")
		@opinnest = Nest.new("Opinions About Other Characters", :opinions, "subjects/characters/nested/opinion_fields")
		@itemnest = Nest.new("Related Items", :possessions, "subjects/characters/nested/possession_fields")
		@prejnest = Nest.new("Personal Prejudices", :prejudices, "subjects/characters/nested/prejudice_fields")
	end
end
