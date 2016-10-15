module Collectables
	class PlacesDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include ListableCollection
		include PageCreating
		include Widgets::Definitions

		# PUBLIC METHODS
		# ------------------------------------------------------------
		def heading
			"Places"
		end

		def title
			heading
		end

		def klass
			@klass ||= :places
		end
		
		def results
			h.render 'results'
		end

		def organized
			Place.organize object
		end

	end
end
