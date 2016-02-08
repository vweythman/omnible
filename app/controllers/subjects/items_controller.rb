class Subjects::ItemsController < SubjectsController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		items
	end

	def show
		item
		can_view? @item, items_path
	end

	def new
		@item = Item.new.decorate
	end

	def edit
		item
		can_edit? @item
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
		item
		can_edit? @item

		if @item.update(item_params)
			redirect_to @item
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		item
		can_destroy? @item

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
		params.require(:item).permit(:name, :nature, :descriptions)
	end

	# Subjects :: find all
	def items
		@subjects = @items = Item.order_by_generic.decorate
	end

end