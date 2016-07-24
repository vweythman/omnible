class ItemDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent
	include CreativeContent::Dossier
	include PageEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def current_tags
		@tags ||= qualities.pluck(:name)
	end

	def description_status
		h.metadata self.generic.name.titleize + ":", list_qualities
	end

	def icon_choice
		'diamonds'
	end

	# -- Lists
	# ............................................................
	def list_qualities
		h.cslinks(self.qualities, class: 'quality')
	end

	def decorated_possessions
		@decorated_possessions ||= Collectables::PossessionsDecorator.decorate(self.possessions.includes(:character))
	end

	def possessors
		decorated_possessions.organize_characters
	end

end
