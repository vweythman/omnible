module Collectables
	class SquadsDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include PageCreating
		include Widgets::ListableResults

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Groups"
		end

		def heading
			"Groups"
		end

		def klass
			:groups
		end

	end
end
