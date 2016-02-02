class Works::Curation::CharacterWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def work_parent
		@parent = Character.find(params[:character_id])
	end

end
