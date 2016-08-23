module Collectables
	class SublocalitiesDecorator < PlaceDecorator

		# MODULES
		# ------------------------------------------------------------
		include NestedFields

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def heading
			"Child Places"
		end

		def klass
			@klass ||= :sublocalities
		end

		def partial
			"subjects/places/fields/subdomain_fields"
		end

		def possible_for(place)
			@places ||= place.potential_subdomains
		end

	end
end
