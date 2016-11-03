module Collectables
	class CreatorCategoriesDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include Widgets::ListableResults

	end
end
