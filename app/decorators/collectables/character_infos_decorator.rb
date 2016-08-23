module Collectables
	class CharacterInfosDecorator < Draper::CollectionDecorator

		# MODULES
		# ------------------------------------------------------------
		include NestedFields

		# PUBLIC METHODS
		# ------------------------------------------------------------
		# -- About
		# ............................................................
		def heading
			"Detail"
		end

		def show_heading
			"Detailed Description"
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
end
