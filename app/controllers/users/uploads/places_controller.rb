class Users::Uploads::PlacesController < Users::UploadsController

	# PUBLIC METHODS
	# ============================================================
	def index
		@uploads = current_user.places.sort_by! { |x| x.heading.downcase }
	end

	def show
		@place = Place.find(params[:id]).decorate

		unless @place.uploader? current_user
			redirect_to root_url
		end
	end

end
