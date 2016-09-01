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
				"Articles"
			end

			def klass
				:articles
			end

			def filter_values
				filters = super
				filters[:order][:values] << { heading: "Word Count", key: "word-count"}
				filters.except!(:completion)
				filters.except!(:content_type)
			end

		end
	end
end
