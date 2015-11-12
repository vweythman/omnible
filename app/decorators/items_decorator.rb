class ItemsDecorator < ListableCollectionDecorator

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

	def possible_possessions
		@possible ||= Item.all
	end

	def list
		h.render partial: list_partial, object: Item.organize(object)
	end

	def creation_path
		h.creation_toolkit "Item", :item
	end

	private
	def list_type
		:definitions
	end

end
