module ApplicationHelper

	# OUTPUT head title
	def full_title(page_title = '')
		base_title = "Omnible"

		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

	# OUTPUT correct article
	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	# OUTPUT toolblock class
	def tool_heading(title, length)
		tag_class = length < 1 ? "tool-label" : nil
		content_tag :h2, class: tag_class do
			title
		end
	end

	# OUTPUT heading for prev link
	def prev_heading(title)
		"&lsaquo; #{title}".html_safe
	end

	# OUTPUT heading for next link
	def next_heading(title)
		"#{title} &rsaquo;".html_safe
	end

	# OUTPUT drop down arrow symbol
	def drop_arrow
		content_tag :span, class: 'drop-arrow' do
			"&#x25BE;".html_safe
		end
	end

	# OUTPUT markdown content
	def markdown(text)
		Kramdown::Document.new(text, :auto_ids => false, :parse_block_html => true).to_html.html_safe
	end
	
	# OUTPUT formated time string
	def record_time(date)
		date.strftime("%b %d, %Y")
	end

	# OUTPUT formated percentage
	def pretty_percentage(value)
		sprintf('%.2f', value) + "%"
	end

	def percent_also_tagged(what, per, left_tag, right_tag)
		pretty_percentage(per) + " of " + what + " tagged " + left_tag + " are also tagged " + right_tag
	end

	def rating_class(lvl)
		"rating level#{lvl}"
	end

	def reversed_rating(tag, lvl, content)
		content_tag tag, class: "level#{4 - lvl}" do
			content
		end
	end
end
