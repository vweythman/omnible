class JournalsDecorator < WorksDecorator

	# MODULES
	# ------------------------------------------------------------
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Journals"
	end

	def klass
		:journals
	end

end
