module Collectables
	class CreatorCategoriesDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include Widgets::ListableResults

		def klass
			:creator_categories
		end

	end
end
