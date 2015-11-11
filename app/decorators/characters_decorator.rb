class CharactersDecorator < ListableCollectionDecorator

	def creation_path
		h.creation_toolkit "Character", h.new_character_path
	end

	private
	def list_type
		:links
	end

end
