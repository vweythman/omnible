module ToggleAbility

	def disable_button(path, label="Disable")
		h.link_to label, path, class: "status-toggle-link", method: :delete, remote: true
	end

	def enable_button(path, label="Enable")
		h.link_to label, path, class: "status-toggle-link", method: :post, remote: true
	end

end
