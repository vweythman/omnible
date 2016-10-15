module WithinCategoryPagination

	def category_pagination(category_list, prev_in_list, next_in_list)
		first_in_list = category_list.first
		last_in_list  = category_list.last

		if first_in_list == self
			link_to_first = nil
			link_to_prev  = nil
		else
			link_to_first = left_paged_link(first_in_list)
			link_to_prev  = left_paged_link(prev_in_list, false)
		end
		if last_in_list == self
			link_to_last = nil
			link_to_next  = nil
		else
			link_to_last = right_paged_link(last_in_list)
			link_to_next = right_paged_link(next_in_list, false)
		end

		h.full_pagination_list(link_to_first, link_to_prev, self.name, link_to_next, link_to_last)
	end

	def right_paged_link(item, is_max = true)
		h.link_to (item.name + (is_max ? " &raquo;" : " &rsaquo;")).html_safe, item
	end

	def left_paged_link(item, is_max = true)
		h.link_to ((is_max ? "&laquo; " : "&lsaquo; ") + item.name).html_safe, item
	end

end