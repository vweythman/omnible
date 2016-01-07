class ChaptersDecorator < Draper::CollectionDecorator

	# MODULES
	# ------------------------------------------------------------
	include Nestable

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- Identifiers
	# ............................................................
	def heading
		"Chapters"
	end

	def klass
		:chapters
	end

	def meta_title(story)
		story.title + " - Chapters"
	end

	def nest_class
		"nested textable"
	end

	# -- Links
	# ............................................................
	def link_to_insert_first(story)
		if story.editable?(h.current_user)
			h.content_tag :nav, class: 'toolkit insertion' do
				h.link_to "+ New Chapter Here", h.first_chapter_path(story)
			end
		end
	end

	# -- Location
	# ............................................................
	def partial
		'works/shared/nested_chapter_fields'
	end

end
