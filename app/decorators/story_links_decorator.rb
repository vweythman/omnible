class StoryLinksDecorator < WorksDecorator

	# MODULES
	# ------------------------------------------------------------
	include PageCreating

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def title
		"Story Links"
	end

	def klass
		:story_links
	end

end
