class Taggings::QualitiesController < TaggingsController

	# PRIVATE METHODS
	# ============================================================
	private

	# Tag :: find by id
	def tag
		@tag = @quality = Quality.friendly.find(params[:id]).decorate
	end
	
	# TagParams :: define strong parameters
	def tag_params
		params.require(:quality).permit(:name, :adjective_id)
	end

	# Tags :: find all
	def tags
		@tags = Quality.order(:name).decorate
	end

end
