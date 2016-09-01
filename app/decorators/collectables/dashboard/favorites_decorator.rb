module Collectables
	module Dashboard
		class FavoritesDecorator < Collectables::FavoritesDecorator

			def title
				@title ||= "My Favorite Works"
			end

			def header
				h.dashboard_header ["Favorite Works (#{self.count})"]
			end

		end
	end
end
