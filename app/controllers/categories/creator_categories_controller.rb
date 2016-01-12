class Categories::CreatorCategoriesController < ApplicationController
	def index
		@creatorships = CreatorCategory.all
	end

	def show
	end

	def new
		@creatorship = CreatorCategory.new
		@creatorship.agentive = ""
	end

	def edit
	end
end
