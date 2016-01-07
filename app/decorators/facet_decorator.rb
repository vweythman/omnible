class FacetDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include AlphabeticPagination
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	def alphabetic_first
		@alphabetic_first ||= Facet.alphabetic.first
	end
	
	def alphabetic_last
		@alphabetic_last ||= Facet.alphabetic.last
	end

end
