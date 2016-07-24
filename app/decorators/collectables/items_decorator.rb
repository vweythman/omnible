module Collectables
	class ItemsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include PageCreating
		include Widgets::Definitions

		# PUBLIC METHODS
		# ------------------------------------------------------------
		# -- About
		# ............................................................
		def heading
			"Items"
		end

		def title
			heading
		end

		def klass
			:items
		end

		# -- Lists
		# ............................................................
		def can_list?
			self.length > 0
		end

	end
end
