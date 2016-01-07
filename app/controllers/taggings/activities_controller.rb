class Taggings::ActivitiesController < TaggingsController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@tags = Activity.all.decorate
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_tag
		@tag = @activity = Activity.friendly.find(params[:id]).decorate
	end
	
	# define strong parameters
	def tag_params
		params.require(:activity).permit(:name)
	end

end
