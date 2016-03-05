class Works::BranchesController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		story
	end

	def show
		story
		branch
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def story
		@work = @story = BranchingStory.find(params[:branching_story_id]).decorate
	end

	def branch
		@branch = @story.branches.find(params[:id]).decorate
	end

end
