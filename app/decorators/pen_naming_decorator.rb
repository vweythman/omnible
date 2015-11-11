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

	def status
		self.prime? ? default_pen : secondary_pen
	end

	private
	def default_pen
		h.content_tag :span, class: 'default-pen' do "Default" end
	end

	def secondary_pen
		h.content_tag :span, class: 'secondary-pen' do "Secondary" end
	end

end
