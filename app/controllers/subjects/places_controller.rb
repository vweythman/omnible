class Subjects::PlacesController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_place,  only: [:show, :edit, :update]
	before_action :find_places, only: [:index]
	before_action :set_type,    only: [:create, :update]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@subjects = @places
		render "subjects/index"
	end

	def show
	end

	def new
		@place = Place.new
		@place = @place.decorate
		set_associations
	end

	def edit
		set_associations
	end

	# POST
	# ............................................................
	def create
		@place = Place.new(place_params)

		if @place.save
			redirect_to @place
		else
			set_associations
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		if @place.update(place_params)
			redirect_to @place
		else
			set_associations
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
		@place = @place.decorate
	end

	def find_places
		@places   = Place.order('forms.name, places.name').includes(:form).decorate
	end

	# define strong parameters
	def place_params
		params.require(:place).permit(:name, :form_id, :fictional,
			localities_attributes:    [:id, :domain_id,    :_destroy],
			sublocalities_attributes: [:id, :subdomain_id, :_destroy]
		)
	end

	# define type
	def set_type
		@form = Form.where(name: params[:place][:nature]).first_or_create
		params[:place][:form_id] = @form.id
	end

	# define components
	def set_associations
		@subdomains = SublocalitiesDecorator.decorate(@place.sublocalities)
		@domains    = LocalitiesDecorator.decorate(@place.localities)
	end
end
