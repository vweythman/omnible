module ContentHelper

	# LIST METHODS
	# ============================================================
	def csnames(list)
		if !list.nil? && list.length > 0
			r = list.map {|i| i.name }
			r.join(", ").html_safe
		end
	end

	# LINK METHODS
	# ============================================================
	def cslinks(links, link_options={})
		r = links.map {|i| link_to i.heading, i, link_options }.join(", ").html_safe
	end

	def offsite_link_to(title, path)
		link_to title, path, class: "offsite-link"
	end

	# FORMATING METHODS
	# ============================================================
	def counter_date(date)
		d = date.split("-")
		d[0] + " " + I18n.t("date.month_names")[d[1].to_i]
	end

	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	def markdown(text)
		Kramdown::Document.new((text.nil? ? "" : text), :auto_ids => false, :parse_block_html => true).to_html.html_safe
	end

	def pretty_percentage(value)
		sprintf('%.2f', value) + "%"
	end

	def record_time(date)
		date.strftime("%b %d, %Y")
	end

end
