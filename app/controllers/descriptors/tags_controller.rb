class Descriptors::TagsController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@tags = Tag.order('name')
	end

	def show
		find_tag
	end

	def new
		@tag = Tag.new
	end

	def edit
		find_tag
	end

	# POST
	# ............................................................
	def create
		@tag = Tag.new(tag_params)

		if @tag.save
			redirect_to(:action => 'index')
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_tag

		if @tag.update(tag_params)
			redirect_to(:action => 'index')
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
		@tag = Tag.find(params[:id]).destroy
		redirect_to(:action => 'index')
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_tag
		@tag = Tag.friendly.find(params[:id])
	end

	# define strong parameters
	def tag_params
		params.require(:tag).permit(:name)
	end

end
