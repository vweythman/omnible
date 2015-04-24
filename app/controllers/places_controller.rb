class PlacesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@places = Place.organized_all
	end

	def show
		find_place
	end

	def new
		@place = Place.new
	end
	def edit
		find_place
	end

	# POST
	# ............................................................
	def create
		set_type
		@place = Place.new(place_params)

		if @place.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		set_type
		find_place

		if @place.update(place_params)
			redirect_to(:action => 'index')
		else
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
	def find_place
		@place = Place.find(params[:id])
	end

	# define strong parameters
	def place_params
		params.require(:place).permit(:name, :form_id)
	end

	# define type
	def set_type
		@form = Form.where(name: params[:place][:type]).first_or_create
		params[:place][:form_id] = @form.id
	end
end
