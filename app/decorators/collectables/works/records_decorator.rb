module Collectables
	module Works
		class RecordsDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Media Records"
			end

			def klass
				@klass ||= :records
			end

			def filter_values
				{}
			end

		end
	end
end
