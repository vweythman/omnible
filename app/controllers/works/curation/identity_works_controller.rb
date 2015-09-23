class Works::Curation::IdentityWorksController < WorksController

	# FILTERS
	before_action :set_parent, only: [:index]

	# MODULES
	# ------------------------------------------------------------
	include CuratedWorks

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def set_parent
		@parent = Identity.find(params[:identity_id])
	end

end
