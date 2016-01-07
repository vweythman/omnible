class Taggings::IdentitiesController < TaggingsController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@tags = Identity.sorted_alphabetic.decorate
	end

	# PATCH/PUT
	# ............................................................
	def update
		@identity.typify params[:identity][:nature]

		if @identity.update(tag_params)
			respond_to do |format|
				format.js
				format.html { redirect_to @tag }
			end
		else
			render action: 'edit'
		end
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_tag
		@tag = @identity = Identity.find(params[:id]).decorate
	end

	# define strong parameters
	def tag_params
		params.require(:identity).permit(:name, :facet_id)
	end
	
end
