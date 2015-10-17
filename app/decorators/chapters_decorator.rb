class ChaptersDecorator < Draper::CollectionDecorator

	def meta_title(story)
		story.title + " - Chapters"
	end

	def formid
		"form_chapters"
	end

	def klass
		:chapters
	end

	def heading
		"Chapters"
	end

	def partial
		'works/shared/nested_chapter_fields'
	end

	def link_to_insert_first(story)
		if story.editable?(h.current_user)
			heading   = "+ New Chapter Here"
			insertion = h.link_to heading, h.first_chapter_path(story)
			h.content_tag :nav, class: 'toolkit insertion' do
				insertion
			end
		end
	end

end
