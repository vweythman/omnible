class AnthologiesDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include Widgets::Recent
	include ListableCollection

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def klass
		:anthologies
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	def list_type
		:links
	end

end
