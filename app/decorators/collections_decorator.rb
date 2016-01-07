class CollectionsDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include Nestable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def heading
		"Works"
	end

	def klass
		:collections
	end

	# -- Location
	# ............................................................
	def partial
		'collection_fields'
	end

end
