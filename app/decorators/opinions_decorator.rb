class OpinionsDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include Nestable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def klass
		:opinions
	end

	def heading
		"Opinions about Others"
	end

	# -- Location
	# ............................................................
	def partial
		"subjects/characters/fields/opinion_fields"
	end

end
