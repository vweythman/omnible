class CharactersDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include ListableCollection
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Characters"
	end

	def heading
		"Characters"
	end

	def klass
		:characters
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def list_type
		:links
	end

end
