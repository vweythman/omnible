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

			def klass
				@klass ||= :work_links
			end

		end
	end
end
