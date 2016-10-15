module CreativeContent

	# CHECK
	# ============================================================
	def multiple_creator_categories?
		creator_categories_count > 1
	end

	# GET
	# ============================================================
	def time_started
		date_meta("Published", created_at)
	end

	def time_updated
		date_meta("Changed", updated_at)
	end

	def creator_categories_count
		@creator_categories_count ||= self.creator_categories.size
	end

	def directory_scenes
		[]
	end

	def directory
		h.directory_kit directory_scenes
	end

	# SET
	# ============================================================
	def icon_choice
		'file-empty'
	end

	def breacrumbing(crumbs)
		h.content_tag :ul, class: "breadcrumbs" do
			crumbs.each do |heading, path|
				h.concat crumb(heading, path)
			end
		end
	end

	def content_category
		klass.to_s.pluralize
	end

	def createables
	end

	# RENDER
	# ============================================================
	# FORM DATA
	# ------------------------------------------------------------
	def creatorship_options
		h.options_for_select(self.creator_categories.pluck(:name, :id))
	end

	def pseudonym_options(creator = nil)
		default_choice = creator.nil? ? self.uploader.pseudonymings.prime_character.id : creator.id
		h.options_for_select(self.uploader.all_pens.pluck(:name, :id), default_choice)
	end

	# PARAGRAPHS
	# ------------------------------------------------------------
	def uploaded_by
		print_byline("Uploaded By:", uploader)
	end

	def timestamps
		time = time_started

		unless just_created?
			time +=  time_updated.html_safe
		end

		h.content_tag :p, class: 'time' do
			time.html_safe
		end
	end

	# SPAN
	# ------------------------------------------------------------
	def byline
		h.content_tag :div, class: 'bylines' do uploaded_by end
	end

	def icon
		h.content_tag :span, class: "icon-#{icon_choice} icon" do '' end
	end

	# TABLE DATA
	# ------------------------------------------------------------
	def creation_data
		h.content_tag :td, :data => {:label => "Creation Date"} do
			h.record_time self.created_at
		end
	end

	def updated_at_data(spn = {})
		rw = spn[:rowspan].nil? ? 1 : spn[:rowspan]
		cl = spn[:colspan].nil? ? 1 : spn[:colspan]

		h.content_tag :td, :rowspan => rw, colspan: cl, :data => {:label => "Update Date"} do
			h.record_time self.updated_at
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private
	def date_label(heading)
		h.content_tag :span, class: "date-label meta-label" do "#{heading}:" end
	end

	def date_meta(heading, stamp)
		h.content_tag :span, class: "date-metadatum content-metadatum" do
			h.concat date_label(heading)
			h.concat h.timestamp(stamp)
		end
	end

	def crumb(heading, path)
		h.content_tag :li, class: "crumb" do h.link_to(heading, path, class: 'crumb-link') end
	end

	def print_byline(title, person)
		byline_label = h.content_tag :span, class: "byline-label meta-label" do title end
		byline_value = h.content_tag :span, class: "byline-value" do h.link_to(person.name, person) end

		h.content_tag :p, class: 'byline-metadatum content-metadatum' do
			(byline_label + byline_value).html_safe
		end
	end

end