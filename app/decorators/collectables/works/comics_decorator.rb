module Collectables
	module Works
		class ArticlesDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Comics"
			end

			def klass
				:comics
			end

			def filter_values
				filters = super
				filters.except!(:content_type)
			end

		end
	end
end
