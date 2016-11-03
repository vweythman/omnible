module CreativeContent

	# TABLE of CONTENTS
	# ============================================================
	# 0. CONSTANTS
	# ------------------------------------------------------------
	# -- Icons - inits all icon choices
	#
	# 1. PUBLIC METHODS
	# ------------------------------------------------------------
	# -- A. Display Blocks
	# ----- breadcrumbs - displays parent navigation links
	# ----- createables - displays creation links for subelements
	# ----- directory   - displays child navigation links
	# ----- timestamps  - collects and displays timestamps
	#
	# -- B. Display Form Data
	# ----- creatorship_options - options for creator title
	# ----- pseudonym_options   - options for creator name
	#
	# -- C. Display Meta Keys and Values
	# ----- creation_data   - table data for creation date
	# ----- time_started    - datum block for creation date
	# ----- time_updated    - datum block for update date
	# ----- uploaded_by     - datum block for uploader
	# ----- updated_at_data - table data for update date
	#
	# -- D. Display Text
	# ----- byline
	# ----- icon
	#
	# -- E. Selection Methods
	# ----- all_crumbs
	# ----- content_category
	# ----- creator_categories_count
	# ----- directory_scenes
	# ----- icon_choice
	# ----- klass
	# ----- primary_pseudonym
	#
	# -- F. Questions
	# ----- has_multiple_creator_categories?
	#
	# 2. PRIVATE METHODS
	# ------------------------------------------------------------
	# -- crumb        - displays navigation link in list item
	# -- date_label   - displays date key
	# -- date_meta    - displays date key and value
	# -- byline_datum - displays byline key and value
	#
	# ============================================================

	# 0. CONSTANTS
	# ============================================================
	# ............................................................
	# ICONS - inits all icon choices
	# ............................................................
	ICONS = {
		anthology: 'stack',
		art: 'image',
		branching_story: 'tree',
		comic: 'image',
		music_video: 'film',
		poem: 'image',
		work_link: 'link',
		record: 'folder',
		short_story: 'file-text',
		story: 'book',
		stylesheet: 'magic-wand',
		place:'earth',
		item: 'diamonds',
		character:'smile',
		casting: 'smile'
	}
	# ============================================================

	# 1. PUBLIC METHODS
	# ============================================================
	# ------------------------------------------------------------
	# 1A. DISPLAY BLOCKS
	# ------------------------------------------------------------
	# breadcrumbs - displays parent navigation links
	# ............................................................
	def breadcrumbs
		h.content_tag :ul, class: "breadcrumbs" do
			all_crumbs.each do |heading, path|
				h.concat crumb(heading, path)
			end
		end
	end

	# createables - displays creation links for subelements
	# ............................................................
	def createables
	end

	# directory - displays child navigation links
	# ............................................................
	def directory
		h.directory_kit directory_scenes
	end

	# timestamps - collects and displays timestamps
	# ............................................................
	def timestamps
		time = time_started
		time += time_updated.html_safe unless just_created?

		h.content_tag :p, class: 'time' do
			time.html_safe
		end
	end

	# ------------------------------------------------------------
	# 1B. DISPLAY FORM DATA
	# ------------------------------------------------------------
	# creatorship_options - options for creator title
	# ............................................................
	def creatorship_options
		h.options_for_select(self.creator_categories.pluck(:name, :id))
	end

	# pseudonym_options - options for creator name
	# ............................................................
	def pseudonym_options(creator = nil)
		h.options_for_select(self.uploader.all_pens.pluck(:name, :id), primary_pseudonym(creator))
	end

	# ------------------------------------------------------------
	# 1C. DISPLAY META DATUM
	# ------------------------------------------------------------
	# creation_data - table data for creation date
	# ............................................................
	def creation_data
		h.content_tag :td, :data => {:label => "Creation Date"} do
			h.record_time self.created_at
		end
	end

	# time_started - datum block for creation date
	# ............................................................
	def time_started
		date_meta("Published", created_at)
	end

	# time_updated - datum block for update date
	# ............................................................
	def time_updated
		date_meta("Changed", updated_at)
	end

	# uploaded_by - datum block for uploader
	# ............................................................
	def uploaded_by
		byline_datum("Uploaded By:", uploader)
	end

	# updated_at_data - table data for update date
	# ............................................................
	def updated_at_data(spn = {})
		rw = spn[:rowspan].nil? ? 1 : spn[:rowspan]
		cl = spn[:colspan].nil? ? 1 : spn[:colspan]

		h.content_tag :td, :rowspan => rw, colspan: cl, :data => {:label => "Update Date"} do
			h.record_time self.updated_at
		end
	end

	# ------------------------------------------------------------
	# 1D. DISPLAY TEXT
	# ------------------------------------------------------------
	def byline
		h.content_tag :div, class: 'bylines' do uploaded_by end
	end

	def icon
		h.content_tag :span, class: "icon-#{icon_choice} icon" do '' end
	end

	# ------------------------------------------------------------
	# 1E. SELECTION METHODS
	# ------------------------------------------------------------
	def all_crumbs
		@all_crumbs ||= []
	end

	def content_category
		klass.to_s.pluralize
	end

	def creator_categories_count
		@creator_categories_count ||= self.creator_categories.size
	end

	def directory_scenes
		@directory_scenes ||= []
	end

	def icon_choice
		CreativeContent::ICONS[klass] || 'file-empty'
	end

	def klass
		@klass ||= object.class.name.underscore.to_sym
	end

	def primary_pseudonym(creator)
		creator.nil? ? self.uploader.pseudonymings.prime_character.id : creator.id
	end

	# ------------------------------------------------------------
	# 1F. QUESTIONS
	# ------------------------------------------------------------
	# has_multiple_creator_categories? - answers count question
	# ............................................................
	def has_multiple_creator_categories?
		creator_categories_count > 1
	end

	# 2. PRIVATE METHODS
	# ============================================================
	private

	# crumb - displays navigation link in list item
	# ............................................................
	def crumb(heading, path)
		h.content_tag :li, class: "crumb" do h.link_to(heading, path, class: 'crumb-link') end
	end

	# date_label - displays date key
	# ............................................................
	def date_label(heading)
		h.content_tag :span, class: "date-label meta-label" do "#{heading}:" end
	end

	# date_meta - displays date key and value
	# ............................................................
	def date_meta(heading, stamp)
		h.content_tag :span, class: "date-metadatum content-metadatum" do
			h.concat date_label(heading)
			h.concat h.timestamp(stamp)
		end
	end

	# byline_datum - displays byline key and value
	# ............................................................
	def byline_datum(title, person)
		byline_label = h.content_tag :span, class: "byline-label meta-label" do title end
		byline_value = h.content_tag :span, class: "byline-value" do h.link_to(person.name, person) end

		h.content_tag :p, class: 'byline-metadatum content-metadatum' do
			(byline_label + byline_value).html_safe
		end
	end

end