class Works::Curation::IdentityWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def work_parent
		@parent = Identity.find(params[:identity_id])
	end

end
