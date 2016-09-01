module Collectables
	class FavoritesDecorator < Draper::CollectionDecorator

		include ListableCollection

		def title
			@title ||= "Favorite Works"
		end

		def heading
			title
		end

		def header
			h.index_header self
		end

		def snippets
			h.render 'shared/results/snippets', listable: self
		end

	end
end
