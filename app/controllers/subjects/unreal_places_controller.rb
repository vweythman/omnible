class Subjects::UnrealPlacesController < Subjects::PlacesController

	# PRIVATE METHODS
	# ============================================================
	private

	def find_places
		@subjects = @places = Place.fictitious.order_by_form.decorate
	end

end
