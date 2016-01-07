class Taggings::TagsController < TaggingsController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@tags = Tag.order('name').all.decorate
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_tag
		@tag = Tag.friendly.find(params[:id]).decorate
	end

	# define strong parameters
	def tag_params
		params.require(:tag).permit(:name)
	end

end
