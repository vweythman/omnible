class Subjects::RealPlacesController < Subjects::PlacesController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def find_places
		@places = Place.actual.order('forms.name, places.name').includes(:form).decorate
	end

end
