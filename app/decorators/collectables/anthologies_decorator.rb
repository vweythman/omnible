module Collectables
	class AnthologiesDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include Widgets::Recent
		include Widgets::ListableResults

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def klass
			:anthologies
		end

	end
end
