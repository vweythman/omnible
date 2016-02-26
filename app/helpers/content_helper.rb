module ContentHelper

	def dashboard_header(s = [])
		content_tag :header, class: "dashboard-header" do
			content_tag :h1 do
				concat "My Dashboard"
				concat subtitles(s)
			end
		end
	end

	def subtitles(s)
		capture do
			s.each do |t|
				concat subtitle t
			end
		end
	end

	# OUTPUT correct article
	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	# OUPUT item label tag
	def subtitle(heading)
		content_tag :span, class: "subtitle" do heading end
	end

	# OUPUT item label tag
	def title(heading)
		content_tag :span, class: "title" do heading end
	end
	
	def time_label(heading)
		content_tag :span, class: "time-label" do heading end
	end

end