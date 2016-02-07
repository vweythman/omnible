class Subjects::Curation::IdentityCharactersController < Subjects::CharactersController

	# MODULES
	# ============================================================
	include CuratedCharacters

	# PRIVATE METHODS
	# ============================================================
	private

	def character_parent
		Work.find(params[:work_id]).decorate
	end

end