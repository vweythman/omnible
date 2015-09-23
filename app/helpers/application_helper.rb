module ApplicationHelper

	# HEAD
	# ------------------------------------------------------------
	# OUTPUT head title
	def full_title(page_title = '')
		base_title = "Omnible"

		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

	def page_style_loc(controller, action)
		collector, type = controller.split('/')
		if type.blank?
			type = collector
		else
			prepend, last = type.split('_')
			if last.blank?
				type = prepend
			elsif prepend != 'short'
				type = last
			end
		end
		
		if action == 'show'
			"templates/" + collector + '/' + type.singularize
		elsif collector == 'devise'
			"templates/sessions"
		else
			generators = ['new', 'edit', 'update', 'create']

			if generators.include? action
				action = "generator"
			end
			"templates/" + action
		end
	end

	# BODY
	# ------------------------------------------------------------

	# Navigation
	# ............................................................

	# OUTPUT drop down arrow symbol
	def drop_arrowed(content)
		arrow = content_tag :span, class: 'drop-arrow' do "&#x25BE;".html_safe end
		(content + arrow).html_safe
	end

	# OUTPUT heading for prev link
	def prev_heading(title)
		"&lsaquo; #{title}".html_safe
	end

	# OUTPUT heading for next link
	def next_heading(title)
		"#{title} &rsaquo;".html_safe
	end

	# Headings
	# ............................................................

	# OUTPUT correct article
	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	# Content
	# ............................................................

	# OUTPUT markdown content
	def markdown(text)
		Kramdown::Document.new(text, :auto_ids => false, :parse_block_html => true).to_html.html_safe
	end
	
	# OUTPUT formated time string
	def record_time(date)
		date.strftime("%b %d, %Y")
	end

	def timestamp(date)
		content_tag :span, class: 'date' do
			record_time(date)
		end
	end

	# OUTPUT comma separated links
	def cslinks(links)
		r = links.map {|i| link_to i.name, i }
		r.join(", ").html_safe
	end

	# User Interaction
	# ............................................................

	# OUTPUT link to uploader
	def uploaded_by(uploader)
		content_tag :p do
			"Uploaded By #{link_to(uploader.name, uploader)}".html_safe
		end
	end

	# OUTPUT toolblock class
	def tool_heading(title, length)
		tag_class = length < 1 ? "tool-label" : nil
		content_tag :h2, class: tag_class do
			title
		end
	end

	def list_filters(type, filters)
		content_tag(:ul) do
			filters.map do |f|
				li = content_tag :li do link_to_filter(f[:heading], type, f[:key]) end
				concat li
			end
		end
	end

	def link_to_filter(label, type, key)
		link_to label, params.merge(type => key)
	end

	# Stats
	# ............................................................

	# OUTPUT formated percentage
	def pretty_percentage(value)
		sprintf('%.2f', value) + "%"
	end

	def percent_also_tagged(what, per, left_tag, right_tag)
		pretty_percentage(per) + " of " + what + " tagged " + left_tag + " are also tagged " + right_tag
	end
	
	def reversed_rating(tag, lvl, content)
		content_tag tag, class: "level#{4 - lvl}" do
			content
		end
	end

end
