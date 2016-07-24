class Taggings::IdentitiesController < TaggingsController

	# PRIVATE METHODS
	# ============================================================
	private

	# Tag :: find by id
	def tag
		@tag = @identity = Identity.find(params[:id]).decorate
	end
	
	# TagParams :: define strong parameters
	def tag_params
		params.require(:identity).permit(:name, :nature)
	end

	# Tags :: find all
	def tags
		@tags = @identities = Collectables::IdentitiesDecorator.decorate Identity.sorted_alphabetic
	end
	
end
