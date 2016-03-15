class CharacterInfosDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include NestedFields

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def heading
		"Details"
	end

	def show_heading
		"Detailed Description"
	end

	def nest_class
		"nested textable"
	end

	def klass
		:details
	end

	# -- Location
	# ............................................................
	def partial
		'subjects/characters/fields/detail_fields'
	end

end
