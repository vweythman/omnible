class Subjects::RealPlacesController < Subjects::PlacesController

	# PRIVATE METHODS
	# ============================================================
	private

	def places
		@subjects = @places = Place.actual.order_by_form.decorate
	end

end
