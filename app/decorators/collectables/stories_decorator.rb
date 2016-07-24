module Collectables
	class StoriesDecorator < Collectables::FictionDecorator

		# MODULES
		# ------------------------------------------------------------
		include PageCreating
		include WithoutLinks

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def klass
			:stories
		end

		def title
			"Chaptered Stories"
		end

		def filter_values
			filters = super
			filters[:order][:values] << { heading: "Word Count",    key: "word-count" }
			filters[:order][:values] << { heading: "Chapter Count", key: "chapter-count" }
			filters.except!(:content_type)
			return filters
		end

	end
end
