class Works::Curation::TagWorksController < WorksController

	# FILTERS
	before_action :set_parent, only: [:index]

	# MODULES
	# ------------------------------------------------------------
	include CuratedWorks

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def set_parent
		@parent = Tag.friendly.find(params[:tag_id])
	end

end
