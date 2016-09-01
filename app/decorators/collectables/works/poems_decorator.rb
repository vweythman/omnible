module Collectables
	module Works
		class PoemsDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Poems"
			end

			def klass
				@klass ||= :poems
			end

			def filter_values
				filters = super
				filters[:order][:values] << { heading: "Line Count", key: "line-count"}
				filters.except!(:completion)
				filters.except!(:content_type)
			end

		end
	end
end
