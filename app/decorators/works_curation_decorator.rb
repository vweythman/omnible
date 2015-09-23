class WorksCurationDecorator < WorksDecorator

	def set_parent(parent)
		@parent = parent
	end

	def title
		@parent.heading + " - Works"
	end

	def heading
		link = h.link_to @parent.heading.titleize, h.polymorphic_path(@parent) 
		link + " / Works"
	end

end
