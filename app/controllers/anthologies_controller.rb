class AnthologiesController < ApplicationController
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@anthologies = Anthology.order('lower(name)').decorate
	end

	def show
		find_anthology
		@works = @anthology.works.decorate
	end

	def new
		@anthology = Anthology.new.decorate
		set_associations
	end

	def edit
		find_anthology
		set_associations
	end

	# POST
	# ............................................................
	def create
		@anthology = Anthology.new(anthology_params)

		if @anthology.save
			redirect_to @anthology
		else
			set_associations
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
			set_associations
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
		@anthology = Anthology.find(params[:id]).decorate
	end

	# define strong parameters
	def anthology_params
		params.require(:anthology).permit(:name, :summary, collections_attributes: [:id, :work_id, :_destroy])
	end

	def set_associations
		@works = CollectionsDecorator.decorate(@anthology.works)
	end
end
