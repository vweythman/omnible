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
	
	def record_time(date)
		date.strftime("%b %d, %Y")
	end

	def node_index(node)
		name = node.class.to_s.tableize
		"#{name}/#{name}"
	end
	
	def creation_header(heading)
		provide(:title, "Create #{heading}")
		content_tag :h1 do
			"Create #{heading}".html_safe
		end
	end

	def edit_header(name, title)
		provide(:title, "Edit #{title}")
		content_tag :h1 do
			"Edit #{name}"
		end
	end
end
