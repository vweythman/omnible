class PenNamingDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent::Dossier
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
		h.content_tag :span, class: 'default-pen' do "default".upcase end
	end

	def secondary_pen
		h.content_tag :span, class: 'secondary-pen' do "secondary" end
	end

	def switch_link
		h.link_to "Make Default", h.pen_naming_switch_path(self.id), class: "status-toggle-link", method: :put, remote: true
	end

end
