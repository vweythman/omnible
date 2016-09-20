class FacetDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include AlphabeticPagination
	include InlineEditing

end
