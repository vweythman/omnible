class Subjects::ItemsController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :find_item, only: [:show, :edit, :update]

	# MODULES
	# ------------------------------------------------------------
	include Tagged

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@items = Item.order('generics.name, items.name').includes(:generic).decorate
	end

	def show
	end

	def new
		@item = Item.new
	end

	def edit
	end

	# POST
	# ............................................................
	def create
		create_tags

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
		@item.typify params[:item][:nature]

		update_tags

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

	# SHOW/UPDATE
	# ............................................................
	# find by id
	def find_item
		@item = Item.friendly.find(params[:id]).decorate
	end

	def update_tags
		list = Quality.batch(params[:descriptions])
		curr = @item.update_tags(list)
		set_tags(list - curr)
	end

	# CREATE
	# ............................................................
	def create_tags
		list = Quality.batch(params[:descriptions])
		set_tags(list)
	end

	# CREATE/UPDATE
	# ............................................................
	# define descriptions of items
	def set_tags(list)
		params[:item][:item_tags_attributes] = build_tags(list, :quality_id)
	end
	
	# define strong parameters
	def item_params
		params.require(:item).permit(:name, :generic_id,
			item_tags_attributes: [:id, :quality_id, :_destroy]
		)
	end

end
