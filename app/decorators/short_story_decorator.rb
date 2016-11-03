class ShortStoryDecorator < WorkDecorator

	# 1. PUBLIC METHODS
	# ============================================================
	# Headings
	# ------------------------------------------------------------
	def creation_title
		"Create Short Story"
	end

	# Navigation
	# ------------------------------------------------------------
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('collected.fiction'), h.fiction_index_path], [h.t('content_types.short_stories'), h.short_stories_path]]
	end

	def directory_scenes
		scenes = []
		scenes << ["Notes", h.short_story_notes_path(self)]
		scenes
	end

	def link_to_self
		h.link_to "Story", h.short_story_path(self)
	end

end
