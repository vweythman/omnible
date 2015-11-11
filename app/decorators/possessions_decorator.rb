class PossessionsDecorator < Draper::CollectionDecorator

	def klass
		:possessions
	end

	def formid
		"form_possessions"
	end

	def partial
		"subjects/characters/fields/possession_fields"
	end

	def heading
		"Items"
	end

	def can_list?
		object.length > 0
	end

	def possible_possessions
		@possible ||= Item.all
	end

	def items 
		values = ""
		Possession.organize_items(object).each do |relator, group|
			values = values + h.subgrouped_list(relator, ItemsDecorator.decorate(group))
		end
		values
	end

	def characters
		values = ""
		Possession.organize_characters(object).each do |relator, group|
			values = values + h.subgrouped_list(relator, CharactersDecorator.decorate(group))
		end
		values
	end

end
