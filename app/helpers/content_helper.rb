module ContentHelper

	# HEADINGS
	# ============================================================
	def dashboard_header(subs = [], hid = nil)
		content_tag :header, class: "dashboard-header" do
			concat dash_heading subs, hid
			yield if block_given?
		end
	end

	def dash_heading(all_titles, hid)
		main_title = all_titles.shift
		content_tag :h1, id: hid do
			concat main_title
			concat subtitles(all_titles)
		end
	end

	def index_header(collection)
		content_tag :header, class: "index-header" do
			concat content_tag :h1, collection.heading
			concat collection.found_status
			yield if block_given?
		end
	end

	def subtitles(s)
		capture do
			s.each do |t|
				concat subtitle t
			end
		end
	end

	# OUPUT item label tag
	def subtitle(heading)
		content_tag :span, class: "subtitle" do heading end
	end

	# OUPUT item label tag
	def title(heading)
		content_tag :span, class: "title" do heading end
	end

	def uploads_url(n = nil)
		"/uploads/#{n}"
	end

	# BODY
	# ============================================================
	def subject_body
		content_tag :div, class: "subject-body" do
			yield
		end
	end

	# DATA
	# ============================================================
	# OUTPUT correct article
	def indefinite_article(phrase)
		article = strip_tags(phrase).lstrip.chop =~ /^[FMNRS][^AEIOUa-z]|^[AEIOUaeiou]/ ? "An" : "A"
		"#{article} #{phrase}".html_safe
	end

	def metadata(ky, val)
		key_string = content_tag :b, class: "key" do (ky) end
		content_tag :p, class: "datum" do
			"#{key_string} #{val}".html_safe
		end
	end
	
	# OUTPUT formated time string
	def record_time(date)
		date.strftime("%b %d, %Y")
	end
	
	def time_label(heading)
		content_tag :span, class: "time-label" do heading end
	end

	def timestamp(date)
		content_tag :span, class: 'date-value' do
			record_time(date)
		end
	end

	def counter_date(date)
		d = date.split("-")
		d[0] + " " + I18n.t("date.month_names")[d[1].to_i]
	end

	# TEXT
	# ============================================================
	# OUTPUT comma separated links
	def cslinks(links, link_options={})
		r = links.map {|i| link_to i.heading, i, link_options }.join(", ").html_safe
	end

	def cstags(links, choice, link_options={})
		r = links.map {|i|
			ul = 
			link_to i.heading, (url_for(i) + '/' + choice), link_options
		}.join(", ").html_safe
	end

	def tag_group(list, group, group_options = {}, tag_options = {})
		content_tag :p, group_options do
			cstags(list, group, tag_options)
		end
	end
	
	def tag_label_by(type, key = nil)
		tag_label = "#{type}-tag tag"
		tag_label = "#{key}-#{type} #{tag_label}" unless key.nil?
		tag_label
	end

	def csnames(list)
		if !list.nil? && list.length > 0
			r = list.map {|i| i.name }
			r.join(", ").html_safe
		end
	end

	# OUTPUT markdown content
	def markdown(text)
		Kramdown::Document.new((text.nil? ? "" : text), :auto_ids => false, :parse_block_html => true).to_html.html_safe
	end

	def indexed_tagging(title, type, count, path)
		if count.present? && count > 0
			content_tag :li, class: 'icon icon-books' do
				(" " + link_to("#{title}: #{type} (#{count})", path)).html_safe
			end
		end
	end

end
