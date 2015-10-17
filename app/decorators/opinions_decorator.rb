class OpinionsDecorator < Draper::CollectionDecorator

	def klass
		:opinions
	end

	def formid
		"form_opinions"
	end

	def partial
		"subjects/characters/fields/opinion_fields"
	end

	def heading
		"Opinions about Others"
	end

end
