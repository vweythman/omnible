class Works::Curation::TagWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def works_parent
		@parent = Tag.friendly.find(params[:tag_id])
	end

end
