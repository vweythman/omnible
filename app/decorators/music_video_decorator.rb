class MusicVideoDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def all_crumbs
		[[h.t('collected.works'), h.works_path], [h.t('content_types.music_videos'), h.poems_path]]
	end

	def title_for_creation
		"Upload Music Video"
	end

end
