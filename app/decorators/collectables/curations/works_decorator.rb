module Collectables
	module Curations
		class WorksDecorator < Collectables::WorksDecorator

			# PUBLIC METHODS
			# ------------------------------------------------------------
			def title
				object.proxy_association.owner.heading + " - Works"
			end

			def heading
				link = h.link_to object.proxy_association.owner.heading, h.polymorphic_path(object.proxy_association.owner) 
				link + h.subtitle(subheading)
			end

			def subheading
				showing_links ? "Works and Links" : "Works"
			end

			def creation_path
				nil
			end

			def for_categories
				nil
			end

		end
	end
end
