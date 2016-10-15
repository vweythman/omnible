class ShortStoryDecorator < WorkDecorator

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# -- About
	# ............................................................
	def creation_title
		"Create Short Story"
	end

	def klass
		@klass ||= :short_story
	end

	def link_to_self
		h.link_to "Story", h.short_story_path(self)
	end

	def icon_choice
		'file-text'
	end

	# -- Navigation
	# ............................................................
	def breadcrumbs
		crumbs = [[h.t('collected.works'), h.works_path], [h.t('collected.fiction'), h.fiction_index_path], [h.t('content_types.short_stories'), h.short_stories_path]]
		breacrumbing(crumbs)
	end

	def directory_scenes
		scenes = []
		scenes << ["Notes", h.short_story_notes_path(self)]
		scenes
	end

end
