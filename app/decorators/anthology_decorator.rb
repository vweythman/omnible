class AnthologyDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include Agented
	include Timestamped
	include PageEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def possible
		@possible_works ||= Work.order('lower(title)').decorate
	end

end
