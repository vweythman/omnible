class Works::Curation::CharacterWorksController < WorksController

	# MODULES
	# ============================================================
	include CuratedWorks
	
	# PRIVATE METHODS
	# ============================================================
	private

	def works_parent
		@parent = Character.find(params[:character_id])
	end

end
