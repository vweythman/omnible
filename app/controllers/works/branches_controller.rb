class Works::BranchesController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		story
		@branches    = @story.branches
		@is_editable = @work.editable? current_user
	end

	def show
		story
		story_branch
	end

	def edit
		branch
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		branch
		cannot_edit? @story do
			return
		end

		if @branch.update(branch_params)
			redirect_to [@story, @branch]
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def story
		@work = @story = BranchingStory.find(params[:branching_story_id]).decorate
	end

	def story_branch
		@branch = @story.branches.find(params[:id]).decorate
	end

	def branch
		@branch = Branch.find(params[:id]).decorate
		@story  = @branch.story
	end

	def branch_params
		params.require(:branch).permit(:title, :content)
	end

end
