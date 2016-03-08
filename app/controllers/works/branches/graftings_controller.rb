class Works::Branches::GraftingsController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def new
		parent_branch
		@branching = Branching.new
	end

	def edit
	end

	# POST
	# ------------------------------------------------------------
	def create
		parent_branch
		child_branch

		if @parent_branch.can_graft_to? @child_branch
			@branching = @parent_branch.child_branchings.new(branching_params)

			if @branching.save
				respond_to do |format|
					format.js   { }
					format.html { redirect_to [@child_branch.story, @child_branch] }
				end
			else
				respond_to do |format|
					format.js   { }
					format.html { render action: 'new' }
				end
			end
		else
			redirect_to [@parent_branch.story, @parent_branch]
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def branching_params
		params.require(:branching).permit(:heading, :child_node_id)
	end

	def parent_branch
		@parent_branch = Branch.find(params[:branch_id]).decorate
	end

	def child_branch
		@child_branch = Branch.find(params[:branching][:child_node_id])
	end

end
