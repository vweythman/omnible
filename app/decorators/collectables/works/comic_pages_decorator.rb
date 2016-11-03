module Collectables
	module Works
		class ComicPagesDecorator < Draper::CollectionDecorator

			# MODULES
			# ------------------------------------------------------------
			include NestedFields

			# PUBLIC METHODS
			# ------------------------------------------------------------
			# -- Identifiers
			# ............................................................
			def heading
				"Pages"
			end

			def meta_title
				owner_heading + " - Pages"
			end

			def owner_heading
				object.proxy_association.owner.title
			end

			# -- Location
			# ............................................................
			def partial
				'page_fields'
			end

			def story
				object.proxy_association.owner
			end

		end
	end
end
