class IdentityDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include AlphabeticPagination
	include WithinCategoryPagination

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def defined_heading
		name.titleize
	end

	def facet_link
		h.link_to facet_title, facet
	end

	def facet_title
		facet.name.titleize
	end

	def faceted_heading
		facet_link + ": " + name.titleize
	end

	def faceted_pagination
		@faceted_pagination ||= category_pagination(self.facet.identities.alphabetic, self.faceted_prev, self.faceted_next)
	end

	def heading
		facet_title + " :: " + name.titleize
	end

	def page_title
		facet.name + " - " + name
	end

end
