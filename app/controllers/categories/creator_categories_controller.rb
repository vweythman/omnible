class Categories::CreatorCategoriesController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :admin_restriction

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		creator_categories
	end

	def show
		creator_category
		@creator_category.describers.reload
	end

	def new
		@creator_category = CreatorCategory.new
	end

	def edit
		creator_category
	end

	# POST
	# ------------------------------------------------------------
	def create
		@creator_category = CreatorCategory.new(category_params)

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
		creator_category

		if @creator_category.update(category_params)
			respond_to do |format|
				format.js   { }
				format.html { redirect_to @creator_category }
			end
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		creator_category

		@creator_category.destroy
		respond_to do |format|
			format.html { redirect_to creator_categories_url }
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

end
