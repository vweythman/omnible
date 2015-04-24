class ItemsController < ApplicationController

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
		set_type
		set_descriptions

		@item = Item.new(item_params)

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

		set_type
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

	# define type
	def set_type
		@generic = Generic.where(name: params[:item][:type]).first_or_create
		params[:item][:generic_id] = @generic.id
	end

	# define descriptions
	def set_descriptions
		@quality_ids = Quality.batch_build params[:descriptions]
		params[:item][:item_descriptions_attributes] = build_tag_list(@quality_ids, :quality_id)
	end

	# update description list
	def update_descriptions
		@quality_ids = Quality.batch_build params[:descriptions]

		# delete missing
		ItemDescription.not_included(@item.id, @quality_ids).destroy_all

		# remove duplicates
		already_exists = ItemDescription.is_included(@item.id, @quality_ids).pluck(:quality_id)
		@quality_ids   = @quality_ids - already_exists

		params[:item][:item_descriptions_attributes] = build_tag_list(@quality_ids, :quality_id)
	end
	
	# define strong parameters
	def item_params
		params.require(:item).permit(:name, :generic_id,
			item_descriptions_attributes: [:id, :quality_id, :_destroy]
		)
	end

end
