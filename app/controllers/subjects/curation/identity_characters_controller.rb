class Subjects::Curation::IdentityCharactersController < Subjects::CharactersController

	# MODULES
	# ============================================================
	include CuratedCharacters

	# PRIVATE METHODS
	# ============================================================
	private

	def character_parent
		Identity.find(params[:identity_id]).decorate
	end

end
