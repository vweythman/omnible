class ArtDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:art
	end

	def most_recent_label
		"Changed"
	end

	def icon_choice
		'image'
	end

	def title_for_creation
		"Upload Art"
	end

end
