class Subjects::Curation::IdentityCharactersController < Subjects::CharactersController

	# FILTERS
	before_action :set_parent, only: [:index]

	# MODULES
	# ------------------------------------------------------------
	include CuratedCharacters

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def set_parent
		@parent = Identity.find(params[:identity_id])
	end

end
