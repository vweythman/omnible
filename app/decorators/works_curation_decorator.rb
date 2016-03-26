class WorksCurationDecorator < WorksDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		object.proxy_association.owner.heading + " - Works"
	end

	def heading
		link = h.link_to object.proxy_association.owner.heading, h.polymorphic_path(object.proxy_association.owner) 
		link + h.subtitle("Works")
	end

	def creation_path
		nil
	end

	def for_categories
		nil
	end

end
