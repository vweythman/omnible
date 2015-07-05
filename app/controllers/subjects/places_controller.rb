class Subjects::PlacesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@places = Place.organized_all
	end

	def real
		@places = Place.organize(Place.actual.order(:name).includes(:form))
		render 'index'
	end

	def unreal
		@places = Place.organize(Place.fictitious.order(:name).includes(:form))
		render 'index'
	end

	def show
		find_place
		@subdomains = Place.organize(@place.subdomains.includes(:form))
		@domains    = Place.organize(@place.domains.includes(:form))
	end

	def new
		@place = Place.new
		set_components
	end

	def edit
		find_place
		set_components
	end

	# POST
	# ............................................................
	def create
		set_type
		@place = Place.new(place_params)

		if @place.save
			redirect_to @place
		else
			set_components
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		set_type
		find_place

		if @place.update(place_params)
			redirect_to @place
		else
			set_components
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
		params.require(:place).permit(:name, :form_id, :fictional,
			localities_attributes:    [:id, :domain_id,    :_destroy],
			sublocalities_attributes: [:id, :subdomain_id, :_destroy]
		)
	end

	# define type
	def set_type
		@form = Form.where(name: params[:place][:type]).first_or_create
		params[:place][:form_id] = @form.id
	end

	# define components
	def set_components
		@domains    = @place.potential_domains
		@subdomains = @place.potential_subdomains
		
		@nested_dom = Nest.new("Parent Places", :localities,    "subjects/places/nested/domain_fields")
		@nested_sub = Nest.new("Child Places",  :sublocalities, "subjects/places/nested/subdomain_fields")
	end
end
