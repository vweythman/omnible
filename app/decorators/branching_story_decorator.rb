class BranchingStoryDecorator < WorkDecorator
	
	# PUBLIC METHODS
	# ============================================================
	def klass
		:branching_story
	end

	def icon_choice
		'tree'
	end

	def directory_scenes
		[["All Branches", h.branching_story_branches_path(self)]]
	end

	def breadcrumbs
		crumbs = [[h.t('collected.works'), h.works_path], [h.t('collected.fiction'), h.fiction_index_path], [h.t('content_types.branching_stories'), h.branching_stories_path]]
		breacrumbing(crumbs)
	end

end
