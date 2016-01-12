class PenNamingDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include NameIdentified
	include InlineEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def page_title
		"Dashboard (Pen Names) - #{self.heading}"
	end

	def status
		self.prime? ? default_pen : switch_link
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def default_pen
		h.content_tag :span, class: 'default-pen' do "Default" end
	end

	def secondary_pen
		h.content_tag :span, class: 'secondary-pen' do "Secondary" end
	end

	def switch_link
		h.link_to "Make Default", h.pen_naming_switch_path(self.id), class: "switch", method: :put, remote: true
	end

end
