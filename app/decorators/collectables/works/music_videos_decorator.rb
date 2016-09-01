module Collectables
	module Works
		class MusicVideosDecorator < Collectables::WorksDecorator

			# MODULES
			# ------------------------------------------------------------
			include PageCreating
			include WithoutLinks

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				"Music Videos"
			end

			def klass
				:music_videos
			end

			def filter_values
				filters = super
				filters.except!(:completion)
				filters.except!(:content_type)
			end

		end
	end
end
