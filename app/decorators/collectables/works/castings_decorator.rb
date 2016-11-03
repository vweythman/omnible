module Collectables
	module Works
		class CastingsDecorator < Collectables::WorksDecorator

			# MODULES
			# ============================================================
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ============================================================
			def title
				"Castings"
			end

			def filter_values
				filters = super
				filters.except!(:completion)
				filters.except!(:content_type)
			end

		end
	end
end
