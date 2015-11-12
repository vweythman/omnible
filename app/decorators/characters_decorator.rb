class CharactersDecorator < ListableCollectionDecorator

	def creation_path
		h.creation_toolkit "Character", :character
	end

	private
	def list_type
		:links
	end

end
