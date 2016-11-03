module Collectables
	module Works
		class WorkLinksDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Links"
			end

		end
	end
end
