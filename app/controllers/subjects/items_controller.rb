class Subjects::ItemsController < SubjectsController

	# FILTERS
	# ============================================================
	before_action :item, only: [:show, :edit, :update, :destroy]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def new
		@item = Item.new.decorate
	end

	# POST
	# ------------------------------------------------------------
	def create
		@item = Item.new(item_params)
		if @item.save
			redirect_to @item
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		if @item.update(item_params)
			redirect_to @item
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		@item.destroy
		respond_to do |format|
			format.html { redirect_to items_url }
			format.json { head :no_content }
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# Item :: find by id
	def item
		@item = Item.friendly.find(params[:id]).decorate
	end

	# ItemParams :: define strong parameters
	def item_params
		params.require(:item).permit(:name, :generic_id, :nature, :descriptions)
	end

	# Subjects :: find all
	def subjects
		@subjects = Item.order_by_generic.decorate
	end

end