class ItemsDecorator < Draper::CollectionDecorator

	def klass
		:items
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
		self.length > 0
	end

	def subheading
		h.content_tag :h2 do
			"Related Item".pluralize(self.length)
		end
	end

	def possible_possessions
		@possible ||= Item.all
	end

	def list
		h.render partial: "shared/definitions", object: Item.organize(object)
	end

end
