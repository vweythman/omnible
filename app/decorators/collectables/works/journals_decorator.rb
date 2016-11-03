module Collectables
	module Works
		class JournalsDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Journals"
			end

		end
	end
end
