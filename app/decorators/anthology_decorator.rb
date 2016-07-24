class AnthologyDecorator < Draper::Decorator

	# DELEGATION
	# ============================================================
	delegate_all

	# MODULES
	# ============================================================
	include CreativeContent
	include PageEditing

	# PUBLIC METHODS
	# ============================================================
	def possible
		@possible_works ||= Work.order('lower(title)').decorate
	end

	def current_works
		@current_works ||= Collectables::CollectionsDecorator.decorate(self.works)
	end

end
