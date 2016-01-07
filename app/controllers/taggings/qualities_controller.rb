class Taggings::QualitiesController < TaggingsController

	# MODULES
	# ------------------------------------------------------------
	include Tagged

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@tags = Quality.order(:name).decorate
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_tag
		@tag = @quality = Quality.friendly.find(params[:id]).decorate
	end
	
	# define strong parameters
	def tag_params
		params.require(:quality).permit(:name, :adjective_id)
	end

end
