class Subjects::RealPlacesController < Subjects::PlacesController

	# PRIVATE METHODS
	# ============================================================
	private

	def find_places
		@subjects = @places = Place.actual.order_by_form.decorate
	end

end
