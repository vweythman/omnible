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
		h.content_tag :p, class: 'about' do
			h.indefinite_article("#{list_qualities} #{self.generic.name}")
		end
	end

	# -- Lists
	# ............................................................
	def list_qualities
		h.cslinks(self.qualities)
	end

	def list_related_characters
		possessions = PossessionsDecorator.decorate(self.possessions.includes(:item, :generic))
		possessions.characters.html_safe if possessions.can_list?
	end

end
