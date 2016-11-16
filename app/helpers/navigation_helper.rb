module NavigationHelper

	# MENU AND SIDEBAR
	# ============================================================
	def drop_arrowed(content)
		arrow = content_tag :span, class: 'drop-arrow' do "&#x25BE;".html_safe end
		(content + arrow).html_safe
	end

	def uploads_path_for(type)
		eval(type.to_s.singularize + '_uploads_path')
	end

	# PAGE NAV
	# ============================================================
	def full_pagination_list(first_item, prev_item, current_item, next_item, last_item)
		render(
			:partial => "shared/lists/pagination_list", 
			:locals  => 
			{
				:first_item   => first_item,
				:prev_item    => prev_item,
				:current_item => current_item,
				:next_item    => next_item,
				:last_item    => last_item
			}
		)
	end

	def next_heading(title)
		"#{title} &rsaquo;".html_safe
	end

	def prev_heading(title)
		"&lsaquo; #{title}".html_safe
	end

end
