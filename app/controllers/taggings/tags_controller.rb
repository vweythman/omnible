class Taggings::TagsController < TaggingsController

	# PRIVATE METHODS
	# ============================================================
	private

	# Tag :: find by id
	def tag
		@tag = Tag.friendly.find(params[:id]).decorate
	end
	
	# TagParams :: define strong parameters
	def tag_params
		params.require(:tag).permit(:name)
	end

	# Tags :: find all
	def tags
		@tags = Collectables::TagsDecorator.decorate Tag.order('name')
	end

end
