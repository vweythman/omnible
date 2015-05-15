class Tags::QualitiesController < ApplicationController

	# MODULES
	# ------------------------------------------------------------
	include Tagged

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@qualities = Quality.order('name').all
	end

	def show
		find_quality
		@items = Item.organize(@quality.items.includes(:generic))
	end

	def new
		@quality = Quality.new
	end

	def edit
		find_quality
	end

	# POST
	# ............................................................
	def create
		@quality = Quality.new(quality_params)
		find_adjectives

		if @quality.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_quality
		find_adjectives

		if @quality.update(quality_params)
			redirect_to @quality
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@quality = Quality.find(params[:id]).destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_quality
		@quality = Quality.friendly.find(params[:id])
	end

	# define strong parameters
	def quality_params
		params.require(:quality).permit(:name, :adjective_id)
	end

	def find_adjectives

	end

end
