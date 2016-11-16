module ApplicationHelper

	# HEAD METHODS
	# ============================================================
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
		collector, type = page_type
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

	# BODY METHODS
	# ============================================================
	def page_class
		x = params[:action]
		x + "-page"
	end

end
