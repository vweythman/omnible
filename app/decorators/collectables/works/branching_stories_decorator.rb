module Collectables
	module Works
		class BranchingStoriesDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Branching Stories"
			end

			def klass
				:branching_stories
			end

			def filter_values
				filters = super
				filters[:order][:values] << { heading: "Word Count", key: "word-count"}
				filters.except!(:content_type)
			end

		end
	end
end
