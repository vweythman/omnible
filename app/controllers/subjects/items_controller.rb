class Subjects::ItemsController < ApplicationController

	# MODULES
	# ------------------------------------------------------------
	include Tagged

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@items = Item.organized_all
	end

	def show
		find_item
	end

	def new
		@item = Item.new
		@descriptions = Array.new
	end

	def edit
		find_item
		@descriptions = @item.qualities.pluck(:name)
	end

	# POST
	# ............................................................
	def create
		set_tags

		@item = Item.new(item_params)
		@item.typify params[:item][:nature]

		if @item.save
			redirect_to @item
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ............................................................
	def update
		find_item
		@item.typify params[:item][:nature]

		update_descriptions

		if @item.update(item_params)
			redirect_to @item
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ............................................................
	def destroy
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	# find by id
	def find_item
		@item = Item.friendly.find(params[:id])
	end

	# define descriptions
	def set_tags(list = Quality.batch(params[:descriptions]).pluck(:id))
		params[:item][:item_tags_attributes] = build_tags(list, :quality_id)
	end

	# update description list
	def update_descriptions
		list = Quality.batch(params[:descriptions]).pluck(:id)
		curr = @item.update_tags(list)
		set_tags(list - curr)
	end
	
	# define strong parameters
	def item_params
		params.require(:item).permit(:name, :generic_id,
			item_tags_attributes: [:id, :quality_id, :_destroy]
		)
	end

end
