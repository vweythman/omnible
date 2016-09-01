module Collectables
	module Works
		class ShortStoriesDecorator < Collectables::Works::FictionDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Short Stories"
			end

			def klass
				@klass ||= :short_stories
			end

			def filter_values
				filters = super
				filters[:order][:values] << { heading: "Word Count",    key: "word-count" }
				filters.except!(:completion)
				filters.except!(:content_type)
			end

		end
	end
end
