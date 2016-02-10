class Subjects::PlacesController < SubjectsController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		places
	end

	def new
		@place = Place.new.decorate
		set_associations
	end

	def edit
		place
		can_edit? @place
		set_associations
	end

	def show
		place
		can_view? @place
	end

	# POST
	# ------------------------------------------------------------
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
	# ------------------------------------------------------------
	def update
		place

		cannot_edit? @place do
			return
		end

		if @place.update(place_params)
			redirect_to @place
		else
			set_associations
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		place

		cannot_destroy? @place do
			return
		end

		@place.destroy
		respond_to do |format|
			format.js   { subjects }
			format.html { redirect_to places_path }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# find by id
	def place
		@place = Place.find(params[:id]).decorate
	end

	# define strong parameters
	def place_params
		params.require(:place).permit(:name, :nature,
			:publicity_level, :editor_level, :fictional,
			localities_attributes:    [:id, :domain_id,    :_destroy],
			sublocalities_attributes: [:id, :subdomain_id, :_destroy]
		)
	end

	def places
		@subjects = @places = Place.order_by_form.decorate
	end

	# define components
	def set_associations
		@subdomains = SublocalitiesDecorator.decorate(@place.sublocalities)
		@domains    = LocalitiesDecorator.decorate(@place.localities)
	end
end
