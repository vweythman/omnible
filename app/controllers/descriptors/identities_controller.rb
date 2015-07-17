class Descriptors::IdentitiesController < ApplicationController

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
		define_components
	end

	def edit
		find_identity
		define_components
	end

	# POST
	# ............................................................
	def create
		@identity = Identity.new(identity_params)
		@identity.typify params[:identity][:nature]

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
		@identity.typify params[:identity][:nature]

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

	# setup form components
	def define_components
		@describe_nest = Nest.new("Characters", :descriptions, "description_fields")
	end
end
