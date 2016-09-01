module Collectables
	module Works
		class JournalArticlesDecorator < Draper::CollectionDecorator

			# MODULES
			# ------------------------------------------------------------
			include NestedFields

			# PUBLIC METHODS
			# ------------------------------------------------------------
			# -- Identifiers
			# ............................................................
			def heading
				"Articles"
			end

			def klass
				:articles
			end

			def meta_title
				owner_heading + " - Articles"
			end

			def owner_heading
				object.proxy_association.owner.title
			end

			def legend_heading
				"Articles"
			end

			# -- Location
			# ............................................................
			def partial
				'works/notes/form_nested_fields'
			end

		end
	end
end
