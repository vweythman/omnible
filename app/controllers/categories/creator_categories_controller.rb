class Categories::CreatorCategoriesController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :can_view?
	before_action :creator_category, only: [:show, :edit, :update, :destroy]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		creator_categories
	end

	def show
		@creator_category.works_type_describers.reload
	end

	def new
		@creator_category = CreatorCategory.new
	end

	# POST
	# ------------------------------------------------------------
	def create
		@creator_category = CreatorCategory.new(facet_params)

		if @creator_category.save
			respond_to do |format|
				format.js   { creator_categories }
				format.html { redirect_to @creator_category }
			end
		else
			render action: 'edit'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		if @creator_category.update(category_params)
			redirect_to @creator_category
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		@creator_category.destory
		respond_to do |format|
			format.html { redirect_to creator_categories_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	def category_params
		params.require(:creator_category).permit(:name, :agentive, :work_types => [])
	end

	# FIND
	# ------------------------------------------------------------
	def creator_category
		@creator_category = CreatorCategory.find(params[:id]).decorate
	end

	def creator_categories
		@creator_categories = CreatorCategory.all.order(:name).decorate
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_view?
		unless user_signed_in? && current_user.site_owner?
			redirect_to root_url
		end
	end

end
