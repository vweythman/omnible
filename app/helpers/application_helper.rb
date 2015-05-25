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

	# OUTPUT drop down arrow symbol
	def drop_arrow
		content_tag :span, class: 'drop-arrow' do
			"&#x25BE;".html_safe
		end
	end

	# OUTPUT correct 
	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	# OUTPUT markdown content
	def markdown(text)
		Kramdown::Document.new(text, :auto_ids => false, :parse_block_html => true).to_html.html_safe
	end
	
	# OUTPUT formated time string
	def record_time(date)
		date.strftime("%b %d, %Y")
	end
end
