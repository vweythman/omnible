class PrejudicesDecorator < Draper::CollectionDecorator

	def klass
		:prejudices
	end

	def formid
		"form_prejudices"
	end

	def partial
		"subjects/characters/fields/prejudice_fields"
	end

	def heading
		"Personal Prejudices"
	end
	
	def facets
		@facets ||= Facet.all.order(:name)
	end

end

