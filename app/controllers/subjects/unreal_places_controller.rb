class Subjects::UnrealPlacesController < Subjects::PlacesController

	# PRIVATE METHODS
	# ============================================================
	private

	def places
		@subjects = @places = Place.fictitious.order_by_form.decorate
	end

end
