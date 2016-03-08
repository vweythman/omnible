class Works::Branches::BubblingsController < WorksController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def new
		parent_branch
		@branching            = Branching.new
		@branching.child_node = Branch.new
	end

	# POST
	# ------------------------------------------------------------
	def create
		parent_branch

		@branching = @parent_branch.child_branchings.new(branching_params)
		@branching.storify_child

		if @branching.save
			redirect_to [@story, @branching.child_node]
		else
			render action: 'new'
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def branching_params
		params.require(:branching).permit(:heading, child_node_attributes: [:title, :content])
	end

	def parent_branch
		@parent_branch = Branch.find(params[:branch_id]).decorate
		@story         = @parent_branch.story
	end

end
