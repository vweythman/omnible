class BranchingStoryDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:article
	end

	def most_recent_label
		"Changed"
	end

end
