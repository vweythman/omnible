module ApplicationHelper
	# OUTPUT head title
	def full_title(page_title = '')
		base_title = "Workadex"

		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

	# OUTPUT markdown content
	def markdown(text)
		Kramdown::Document.new(text, :auto_ids => false, :parse_block_html => true).to_html.html_safe
	end
	
	def node_index(node)
		name = node.class.to_s.tableize
		"#{name}/#{name}"
	end

	def related_character(character_id, relationship)
		if relationship.left_id == character_id
			relate = relationship.relator.left_joiner
			recip  = relationship.right
		else
			relate = relationship.relator.right_joiner
			recip  = relationship.left
		end
		
		content_tag :li do 
			"the #{relate} #{link_to recip.name, recip}".html_safe
		end
	end
end
