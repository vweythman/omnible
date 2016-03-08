class Works::Branches::BranchingsController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	def edit
		branching
		@parent_branch = @branching.parent_node.decorate
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		branching
		@work = @branching.story

		cannot_edit? @work do
			return
		end

		if @branching.update(branching_params)
			respond_to do |format|
				format.html { redirect_to branching_story_branches_path(@work) }
				format.json { head :no_content  }
			end
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy 
		branching
		@work = @branching.story

		cannot_destroy? @work do
			return
		end

		unless @branching.can_uproot?
			redirect_to @work
			return
		end

		@branching.destroy
		redirect_to branching_story_branches_path(@work)
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def branching_params
		params.require(:branching).permit(:heading, :child_node_id)
	end

	def branching
		@branching = Branching.find(params[:id]).decorate
	end

end
