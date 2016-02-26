class WorksCurationDecorator < WorksDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def set_parent(parent)
		@parent = parent
	end

	def title
		@parent.heading + " - Works"
	end

	def heading
		link = h.link_to @parent.heading.titleize, h.polymorphic_path(@parent) 
		link + h.subtitle("Works")
	end

	def creation_path
		nil
	end

	def for_categories
		nil
	end

end
