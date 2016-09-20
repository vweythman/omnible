module AlphabeticPagination

	# SET
	# ============================================================
	def alphabetic_all
		@alphabetic_all ||= object.class.alphabetic
	end

	def alphabetic_first
		@alphabetic_first ||= alphabetic_all.first
	end

	def alphabetic_last
		@alphabetic_last ||= alphabetic_all.last
	end

	# CHECK
	# ============================================================
	def is_alphabetic_first?
		alphabetic_first == self
	end

	def is_alphabetic_last?
		alphabetic_last == self
	end

	# RENDER
	# ============================================================
	# BLOCK
	# ------------------------------------------------------------
	def alphabetic_pagination
		h.full_pagination_list(link_to_alphabetic_first, link_to_alphabetic_prev, self.name, link_to_alphabetic_next, link_to_alphabetic_last)
	end

	# LINKS
	# ------------------------------------------------------------
	def link_to_alphabetic_first
		unless self.is_alphabetic_first?
			h.link_to "&lsaquo; #{alphabetic_first.name}".html_safe, self.alphabetic_first
		end
	end

	def link_to_alphabetic_prev
		unless self.is_alphabetic_first?
			h.link_to "&lsaquo; #{alphabetic_prev.name}".html_safe, self.alphabetic_prev
		end
	end

	def link_to_alphabetic_next
		unless self.is_alphabetic_last?
			h.link_to "#{alphabetic_next.name} &rsaquo;".html_safe, self.alphabetic_next
		end
	end

	def link_to_alphabetic_last
		unless self.is_alphabetic_last?
			h.link_to "#{alphabetic_last.name} &raquo;".html_safe, self.alphabetic_last
		end
	end

end