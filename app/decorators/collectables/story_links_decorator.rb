module Collectables
	class StoryLinksDecorator < Collectables::WorksDecorator

		# MODULES
		# ------------------------------------------------------------
		include PageCreating

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def title
			"Story Links"
		end

		def klass
			:story_links
		end

	end
end
