class Categories::WorkCategoriesController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :admin_restriction

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		work_categories
	end

	def show
		work_category
		@in_use_count  = @work_category.works.count
		@used_by_count = @work_category.uploaders.count
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# FIND
	# ------------------------------------------------------------
	def work_category
		@work_category = WorksTypeDescriber.find(params[:id])
	end

	def work_categories
		@work_categories = WorksTypeDescriber.order(:name)
	end

end
