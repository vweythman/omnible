class CharacterInfosDecorator < Draper::CollectionDecorator


	def formid
		"form_details"
	end

	def klass
		:details
	end

	def heading
		"Details"
	end

	def partial
		'subjects/characters/fields/detail_fields'
	end

end
