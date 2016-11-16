module ContentMetaHelper

	# HEADER
	# ============================================================
	def dashboard_header(subs = [], hid = nil)
		content_tag :header, class: "dashboard-header" do
			concat dash_heading subs, hid
			yield if block_given?
		end
	end

	def index_header(collection)
		content_tag :header, class: "index-header" do
			concat content_tag :h1, collection.heading
			concat collection.found_status
			yield if block_given?
		end
	end

	def metadata(ky, val)
		key_string = content_tag :b, class: "key" do (ky) end
		content_tag :p, class: "datum" do
			"#{key_string} #{val}".html_safe
		end
	end
	
	def time_label(heading)
		content_tag :span, class: "time-label" do heading end
	end

	def timestamp(date)
		content_tag :span, class: 'date-value' do
			record_time(date)
		end
	end

	def uploaded_by(uploader)
		content_tag :p do
			"Uploaded By #{link_to(uploader.name, uploader)}".html_safe
		end
	end

	# HEADINGS
	# ============================================================
	def dash_heading(all_titles, hid)
		main_title = all_titles.shift
		content_tag :h1, id: hid do
			concat main_title
			concat subtitles(all_titles)
		end
	end

	def subtitle(heading)
		content_tag :span, class: "subtitle" do heading end
	end

	def subtitles(s)
		capture do
			s.each do |t|
				concat subtitle t
			end
		end
	end

	def title(heading)
		content_tag :span, class: "title" do heading end
	end

	# BODY
	# ============================================================
	def reversed_rating(tag, lvl, content)
		content_tag tag, class: "level#{4 - lvl}" do
			content
		end
	end

	def subject_body
		content_tag :div, class: "subject-body" do
			yield
		end
	end

end
