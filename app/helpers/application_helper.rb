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

	def page_type
		collector, type = params[:controller].split('/')

		if type.blank?
			type = collector
		else
			prepend, last = type.split('_')
			if (last.blank? || last == collector)
				type = prepend
			elsif prepend == collector || prepend == "whole"
				type = last
			end
		end

		return [collector, type.singularize]
	end

	def style_location
		collector, type = page_type()
		action          = (type == "tagging") ? "index" : params[:action]
		
		# DASHBOARD STYLESHEET
		if ((["users", "admin"].include? collector) && (collector != type) || collector == "categories" && action == "index")
			template_type = "dashboard"

		elsif type.ends_with? 'discussion'
			template_type = 'discussion'
	
		# STATS
		elsif type.starts_with? 'about_all'
			template_type = "about_all"
		
		# SESSION STYLESHEET
		elsif collector == 'devise'
			template_type = "sessions"
		
		# EDITING AND CREATING STYLESHEET
		elsif ['new', 'edit', 'update', 'create'].include? action
			template_type = "forms"
		
		# INDEX AND SHOW STYLESHEET
		else
			template_type = action
		end

		"templates/" + template_type
	end

	def page_class
		x = params[:action]
		x + "-page"
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

	# User Interaction
	# ............................................................

	# OUTPUT link to uploader
	def uploaded_by(uploader)
		content_tag :p do
			"Uploaded By #{link_to(uploader.name, uploader)}".html_safe
		end
	end

	def offsite_link_to(title, path)
		link_to title, path, class: "offsite-link"
	end

	def link_to_filter(label, type, key)
		link_to label, params.merge(type => key)
	end

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
