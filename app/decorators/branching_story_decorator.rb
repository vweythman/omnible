class BranchingStoryDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:branching_story
	end

	def most_recent_label
		"Changed"
	end

	def icon_choice
		'tree'
	end

end
