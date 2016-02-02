class ChapterDecorator < Draper::Decorator

	# DELEGATION
	# ------------------------------------------------------------
	delegate_all

	# MODULES
	# ------------------------------------------------------------
	include CreativeContent
	include CreativeContent::Composition
	include PageEditing

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def afterward_foot
		if afterward.present?
			h.content_tag :footer do
				h.markdown afterward
			end
		end
	end

	def meta_title
		story.title + " - " + heading
	end

	def positioned_heading
		object.title.blank? ? default_heading : default_heading + ": " + object.title
	end

	# -- Creating & Editing
	# ............................................................
	def creation_title
		"Create Chapter"
	end

	def editor_heading
		link = h.link_to story.title, story
		h.content_tag :h1, class: 'ref' do "Edit Chapter of #{link}".html_safe end
	end

	def editing_title
		meta_title + " (Edit Draft)"
	end

	# -- Status
	# ............................................................
	def summarized
		if about.present?
			h.content_tag :div, class: 'about' do
				h.markdown self.about
			end
		end
	end

	# -- Pagination
	# ............................................................
	# ----- Collected
	# ------------------------------
	def pagination
		if self.story.chapters.length > 1
			midpoint  = all_links_selection
			
			strtpoint = link_to_first
			endpoint  = link_to_last

			prvpoint  = link_to_prev
			nxtpoint  = link_to_next
			
			h.pagination_list(strtpoint, prvpoint, midpoint, nxtpoint, endpoint)
		end
	end

	def all_links_selection
		@selectable_links ||= selectable_chapter_links
	end

	# ----- End Points
	# ------------------------------
	def first_in_story
		@first_in_story ||= ordered_chapters.first
	end

	def last_in_story
		@last_in_story ||= ordered_chapters.last
	end

	def link_to_first
		unless self.is_first?
			h.link_to "&laquo; First".html_safe, [self.story, self.first_in_story]
		end
	end

	def link_to_last
		unless self.is_last?
			h.link_to "Last &raquo;".html_safe, [self.story, self.last_in_story]
		end
	end

	# ----- Mid Points
	# ------------------------------
	def link_to_prev
		unless self.is_first?
			h.link_to "&lsaquo; Prev".html_safe, [self.story, self.prev]
		end
	end

	def link_to_next
		unless self.is_last?
			h.link_to "Next &rsaquo;".html_safe, [self.story, self.next]
		end
	end

	def link_to_insert_next
		if self.editable?(h.current_user)
			heading   = "+ New Chapter Here"
			insertion = h.link_to heading, h.insert_chapter_path(self)
			h.content_tag :nav, class: 'toolkit insertion' do
				insertion
			end
		end
	end

	# -- Position Checks
	# ------------------------------
	def is_first?
		first_in_story == self
	end

	def is_last?
		last_in_story == self
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def selectable_chapter_links
		ht = Hash.new
		cs = self.story.chapters.select(:title, :id).decorate
		cs.map {|c| ht[h.story_chapter_path(self.story, c)] = c.heading }
		
		h.select_tag('chapter-links', h.options_from_collection_for_select(ht, :first, :last, selected: h.story_chapter_path(self.story, self)))
	end

	def ordered_chapters
		@ordered_chapters ||= self.story.chapters.ordered
	end

end
