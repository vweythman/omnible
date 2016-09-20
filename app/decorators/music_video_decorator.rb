class MusicVideoDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		@klass ||= :music_video
	end

	def icon_choice
		'film'
	end

	def title_for_creation
		"Upload Music Video"
	end

	def breadcrumbs
		crumbs = [[h.t('collected.works'), h.works_path], [h.t('content_types.music_videos'), h.poems_path]]
		breacrumbing(crumbs)
	end

end
