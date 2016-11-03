module Collectables
	class CharactersDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include PageCreating
		include Widgets::ListableResults

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Characters"
		end

		def heading
			"Characters"
		end

	end
end
