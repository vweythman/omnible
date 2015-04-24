class ConceptsController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@concepts = Concept.order('name').all
	end

	def show
		find_concept
	end

	def new
		@concept = Concept.new
	end

	def edit
		find_concept
	end

	# POST
	# ............................................................
	def create
		@concept = Concept.new(concept_params)

		if @concept.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_concept

		if @concept.update(concept_params)
			redirect_to(:action => 'index')
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@concept = Concept.find(params[:id]).destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_concept
		@concept = Concept.friendly.find(params[:id])
	end

	# define strong parameters
	def concept_params
		params.require(:concept).permit(:name)
	end

end
