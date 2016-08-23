class PoemDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		@klass ||= :poem
	end

	def most_recent_label
		"Changed"
	end

	def icon_choice
		'image'
	end

	def title_for_creation
		"Create Poem"
	end

end
