module Collectables
	class RecordsDecorator < Collectables::WorksDecorator

		# MODULES
		# ------------------------------------------------------------
		include PageCreating
		include WithoutLinks

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Records"
		end

		def klass
			:records
		end

		def filter_values
			filters = super
			filters.except!(:completion)
			filters.except!(:content_type)
		end

	end
end
