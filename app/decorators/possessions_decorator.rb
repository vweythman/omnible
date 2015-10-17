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

	def subheading
		h.content_tag :h2 do
			"Related Item".pluralize(object.length)
		end
	end

	def possible_possessions
		@possible ||= Item.all
	end

	def items
		list   = Possession.organize_items(object)
		values = ""
		list.each do |relator, type_group|
			label  = h.content_tag :h2 do relator end
			values = values + label
			values = values + h.render( partial: "shared/definitions", object: type_group)
		end
		values
	end

	def characters
		list   = Possession.organize_characters(object)
		values = ""
		list.each do |relator, characters|
			label  = h.content_tag :h2 do relator end
			values = values + label
			values = values + h.lilinks(characters)
		end
		values
	end

end
