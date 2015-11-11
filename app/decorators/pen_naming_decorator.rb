class PenNamingDecorator < Draper::Decorator
	delegate_all

	def heading
		self.name
	end

	def page_title
		"Dashboard (Pen Names) - #{self.heading}"
	end

	def edit_bar
		h.inline_alteration_toolkit self
	end

end
