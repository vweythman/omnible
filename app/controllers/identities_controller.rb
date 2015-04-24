class IdentitiesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@identities = Identity.organized_all
	end

	def show
		find_identity
	end

	def new
		@identity = Identity.new
	end

	def edit
		find_identity
	end

	# POST
	# ............................................................
	def create
		set_type
		@identity = Identity.new(identity_params)

		if @identity.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_identity
		set_type

		if @identity.update(identity_params)
			redirect_to(:action => 'index')
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@identity = Identity.find(params[:id]).destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	
	# find by id
	def find_identity
		@identity = Identity.find(params[:id])
	end

	# define strong parameters
	def identity_params
		params.require(:identity).permit(:name, :facet_id, 
			descriptions_attributes: [:id, :character_id, :_destroy]
		)
	end

	# define type
	def set_type
		@facet = Facet.where(name: params[:identity][:type]).first_or_create
		params[:identity][:facet_id] = @facet.id
	end

end
