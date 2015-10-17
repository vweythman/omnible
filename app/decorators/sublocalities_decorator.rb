class SublocalitiesDecorator < PlaceDecorator

	def heading
		"Child Places"
	end

	def formid
		"form_sublocalities"
	end

	def klass
		:sublocalities
	end

	def partial
		"subjects/places/fields/subdomain_fields"
	end

	def possible_for(place)
		@places ||= place.potential_subdomains
	end


end
