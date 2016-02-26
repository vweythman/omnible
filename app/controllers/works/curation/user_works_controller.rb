class Works::Curation::UserWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def works_parent
		@parent = User.find(params[:user_id])
	end

end
