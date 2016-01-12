class CharacterInfosDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include Nestable

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

	def subarticle
		h.render :partial => "subjects/characters/details", :locals => { details: self }
	end

	# -- Location
	# ............................................................
	def partial
		'subjects/characters/fields/detail_fields'
	end

end
