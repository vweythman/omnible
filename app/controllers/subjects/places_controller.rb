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
	end

	def edit
		place
		can_edit? @place
	end

	def show
		place
		can_view? @place
	end

	# POST
	# ------------------------------------------------------------
	def create
		@place = Place.new(place_params)
		set_visitor

		if @place.save
			redirect_to @place
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		place
		set_visitor

		cannot_edit? @place do
			return
		end

		if @place.update(place_params)
			redirect_to @place
		else
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

	# define strong parameters
	def place_params
		params.require(:place).permit(
			:name, 
			:uptree,          :downtree,
			:nature,          :fictionality, 
			:domainables,     :subdomainables, 
			:publicity_level, :editor_level, :visitor, 
		)
	end

	# find by id
	def place
		@place = Place.find(params[:id]).decorate
	end

	def places
		@subjects = @places = Place.order_by_form.decorate
	end

	def set_visitor
		@place.uploader ||= current_user
		@place.visitor    = current_user
	end

end
