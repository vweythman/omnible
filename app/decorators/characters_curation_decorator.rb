class CharactersCurationDecorator < Draper::CollectionDecorator
	def set_parent(parent)
		@parent = parent
	end
end
