class MusicVideoDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:music_video
	end

	def icon_choice
		'film'
	end

	def title_for_creation
		"Upload Music Video"
	end

end
