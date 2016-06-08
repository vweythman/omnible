class PlaceDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include CreativeContent::Dossier
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	# GETTERS
	# ------------------------------------------------------------
	def editing_title
		name + " (Edit Draft)"
	end

	def form_status
		form.name.titleize
	end

	def icon_choice
		'earth'
	end

	def reality_status
		@status ||= fictional? ? "Fictional" : "Real"
	end

	def realness_choices
		["Actual Place", "Fictitious Place"]
	end

	def current_realness
		fictional? ? realness_choices.last : realness_choices.first
	end

	def organized_domains
		Place.organize domains.order_by_form
	end

	def organized_subdomains
		Place.organize subdomains.order_by_form
	end

end
