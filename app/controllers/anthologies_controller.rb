class AnthologiesController < ApplicationController
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@anthologies = Anthology.order('lower(name)').all
	end

	def show
		find_anthology
		@works = @anthology.works
	end

	def new
		@anthology = Anthology.new
		@works     = Work.order('lower(title)').all
		@anthology.collections.build
		define_components
	end

	def edit
		find_anthology
		@works = Work.order('lower(title)').all
		define_components
	end

	# POST
	# ............................................................
	def create
		@anthology = Anthology.new(anthology_params)

		if @anthology.save
			redirect_to @anthology
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_anthology

		if @anthology.update(anthology_params)
			redirect_to @anthology
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@anthology = Anthology.find(params[:id]).destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_anthology
		@anthology = Anthology.find(params[:id])
	end

	# define strong parameters
	def anthology_params
		params.require(:anthology).permit(:name, :summary, collections_attributes: [:id, :work_id, :_destroy])
	end

	# setup form components
	def define_components
		@worknest = Nest.new("Works", :collections, "collection_fields")
	end
end
