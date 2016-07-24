module Collectables
	class ArtworkDecorator < Collectables::WorksDecorator

		# MODULES
		# ------------------------------------------------------------
		include PageCreating
		include WithoutLinks

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Art"
		end

		def klass
			:artwork
		end

		def filter_values
			filters = super
			filters.except!(:completion)
			filters.except!(:content_type)
		end

	end
end
