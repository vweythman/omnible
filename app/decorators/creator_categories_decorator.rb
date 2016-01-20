class CreatorCategoriesDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include ListableCollection

	def klass
		:creator_categories
	end

	def list_type
		:links
	end

end
