class Subjects::UnrealPlacesController < Subjects::PlacesController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def find_places
		@places = Place.fictitious.order('forms.name, places.name').includes(:form).decorate
	end

end
