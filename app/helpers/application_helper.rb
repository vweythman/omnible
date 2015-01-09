module ApplicationHelper
	def full_title(page_title = '')
		base_title = "Workadex"

		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

	def return_path(title, path=url_path)
		link_to title, path, :class => 'return'
	end

	def markdown(text)
		options = {
			filter_html:     true,
			hard_wrap:       true, 
			link_attributes: { rel: 'nofollow', target: "_blank" },
			space_after_headers: true, 
			fenced_code_blocks: true
		}

		extensions = {
			autolink:           true,
			superscript:        true,
			disable_indented_code_blocks: true
		}

		renderer = Redcarpet::Render::HTML.new(options)
		markdown = Redcarpet::Markdown.new(renderer, extensions)

		markdown.render(text).html_safe
	end
end
