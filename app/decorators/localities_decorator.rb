class LocalitiesDecorator < PlaceDecorator

	# MODULES
	# ------------------------------------------------------------
	include Nestable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def heading
		"Parent Places"
	end

	def klass
		:localities
	end

	def partial
		"subjects/places/fields/domain_fields"
	end

	def possible_for(place)
		@places ||= place.potential_domains
	end

end
