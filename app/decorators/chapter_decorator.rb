class ChapterDecorator < EditableDecorator
	
	delegate_all

	# HEADINGS
	# ------------------------------------------------------------
	def creation_title
		"Create Chapter"
	end

	def meta_title
		story.title + " - " + heading
	end

	def heading
		object.title.blank? ? "Chapter #{self.position}" : object.title
	end

	def positioned_heading
		title = "Chapter #{self.position}"

		object.title.blank? ? title : title + ": " + object.title
	end

	def editing_title
		meta_title + " (Edit Draft)"
	end

	def editor_heading
		link = h.link_to story.title, story
		h.content_tag :h1, class: 'ref' do "Edit Chapter of #{link}".html_safe end
	end

	# ABOUT
	# ------------------------------------------------------------
	def afterward_foot
		if afterward.present?
			h.content_tag :footer do
				h.markdown afterward
			end
		end
	end

	def summarized
		if about.present?
			h.content_tag :div, class: 'summary' do
				h.markdown self.about
			end
		end
	end

	def length_status
		h.number_with_delimiter(self.word_count, :delimiter => ",") + " Words"
	end

	def length_data
		h.content_tag :td, :data => {:label => "Word Count"} do
			length_status
		end
	end


	# RELATED MODELS
	# ------------------------------------------------------------
	def link_to_prev
		unless self.prev.nil?
			h.link_to "&laquo; Prev".html_safe, [self.story, self.prev]
		end
	end

	def link_to_next
		unless self.next.nil?
			h.link_to "Next &raquo;".html_safe, [self.story, self.next]
		end
	end

	def pagination
		prv = h.content_tag :li, class: 'prev' do link_to_prev end
		nxt = h.content_tag :li, class: 'next' do link_to_next end
		h.content_tag :ol, class: 'pagination' do
			prv + nxt 
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

end
