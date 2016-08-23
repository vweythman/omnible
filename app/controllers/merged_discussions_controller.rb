class Works::MergedDiscussionsController < DiscussionsController

	# PUBLIC METHODS
	# ============================================================
	def show
		discussed

		if has_root?
			comments_thread
		else
			full_comments
		end
		
		render "discussions/merged/show"
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def discussed
		@discussed = Work.find params[:id]
	end

end
