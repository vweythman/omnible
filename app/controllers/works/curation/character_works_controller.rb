class Works::Curation::CharacterWorksController < WorksController

	# FILTERS
	before_action :set_parent, only: [:index]

	# MODULES
	# ------------------------------------------------------------
	include CuratedWorks
	
	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def set_parent
		@parent = Character.find(params[:character_id])
	end

end
