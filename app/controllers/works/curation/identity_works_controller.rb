class Works::Curation::IdentityWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def works_parent
		@parent = Identity.find(params[:identity_id])
	end

end
