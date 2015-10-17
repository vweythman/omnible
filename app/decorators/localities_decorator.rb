class LocalitiesDecorator < PlaceDecorator
  
	def heading
		"Parent Places"
	end

	def formid
		"form_localities"
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
