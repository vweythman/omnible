class Categories::CreatorCategoriesController < ApplicationController
	# FILTERS
	# ------------------------------------------------------------
	before_action :find_index, only: [:index]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
	end

	def show
	end

	def new
		@creatorship = CreatorCategory.new
		@creatorship.agentive = ""
	end

	def edit
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	def find_index
		unless user_signed_in? && current_user.site_owner?
			redirect_to root_url
		end
		@creatorships = CreatorCategory.all.decorate
	end

end
