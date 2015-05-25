class Tags::RelatorsController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@relators = Relator.order('left_name').all
	end

	def show
		find_relator
	end

	def new
		@relator = Relator.new
		define_components
	end

	def edit
		find_relator
		define_components
	end

	# POST
	# ............................................................
	def create
		@relator = Relator.new(relator_params)
		if @relator.save
			redirect_to @relator
		else
			define_components
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_relator

		if @relator.update(relator_params)
			redirect_to @relator
		else
			define_components
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_relator
		@relator = Relator.find(params[:id])
	end

	# define strong parameters
	def relator_params
		params.require(:relator).permit(:right_name, :left_name, 
			connections_attributes: [:id, :left_id, :right_id, :_destroy]
		)
	end
	def define_components
		@connest = Nest.new("Connections", :connections, "connection_fields")
	end
end
