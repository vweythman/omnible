class PrejudicesDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include Nestable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def heading
		"Personal Prejudices"
	end

	def nest_class
		"nested identities prejudices"
	end

	def klass
		:prejudices
	end

	# -- Location
	# ............................................................
	def partial
		"subjects/characters/fields/prejudice_fields"
	end

	# -- Related
	# ............................................................
	def facets
		@facets ||= Facet.all.order(:name)
	end

	def all_identities
		@identities ||= Identity.order(:name)
	end

end

