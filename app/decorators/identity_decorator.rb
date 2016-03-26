class IdentityDecorator < TagDecorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include AlphabeticPagination

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def facet_link
		h.link_to facet_title, facet
	end

	def facet_title
		facet.name.titleize
	end

	def heading
		facet_title + " :: " + name.titleize
	end

	def faceted_heading
		facet_link + ": " + name.titleize
	end

	def page_title
		facet.name + " - " + name
	end

	# -- Pagination
	# ............................................................
	# ----- General
	# ------------------------------
	def faceted_pagination
		h.full_pagination_list(link_to_first, link_to_prev, self.name, link_to_next, link_to_last)
	end

	def alphabetic_first
		@alphabetic_first ||= Identity.alphabetic.first
	end

	def alphabetic_last
		@alphabetic_last ||= Identity.alphabetic.last
	end

	# ----- End Points
	# ------------------------------
	def first_in_facet
		@first_in_facet ||= self.facet.identities.alphabetic.first
	end

	def last_in_facet
		@last_in_facet ||= self.facet.identities.alphabetic.last
	end

	def link_to_first
		unless self.is_first_in_facet?
			h.link_to "&laquo; #{first_in_facet.name}".html_safe, self.first_in_facet
		end
	end

	def link_to_last
		unless self.is_last_in_facet?
			h.link_to "#{last_in_facet.name} &raquo;".html_safe, self.last_in_facet
		end
	end

	# ----- Mid Points
	# ------------------------------
	def link_to_prev
		unless self.is_first_in_facet?
			h.link_to "&lsaquo; #{faceted_prev.name}".html_safe, self.faceted_prev
		end
	end
	
	def link_to_next
		unless self.is_last_in_facet?
			h.link_to "#{faceted_next.name} &rsaquo;".html_safe, self.faceted_next
		end
	end

	# -- Position Checks
	# ------------------------------
	def is_first_in_facet?
		first_in_facet == self
	end

	def is_last_in_facet?
		last_in_facet == self
	end

end
