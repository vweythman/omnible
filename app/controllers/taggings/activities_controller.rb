class Taggings::ActivitiesController < TaggingsController

	# PRIVATE METHODS
	# ============================================================
	private

	# Tag :: find by id
	def tag
		@tag = @activity = Activity.friendly.find(params[:id]).decorate
	end
	
	# TagParams :: define strong parameters
	def tag_params
		params.require(:activity).permit(:name)
	end

	# Tags :: find all
	def tags
		@tags = Activity.all.decorate
	end

end
