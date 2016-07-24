class Subjects::ItemsController < SubjectsController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		items
	end

	def show
		find_item
		can_view? @item, items_path
	end

	def new
		@item = Item.new.decorate
	end

	def edit
		find_item
		can_edit? @item
	end

	# POST
	# ------------------------------------------------------------
	def create
		@item = Item.new(item_params)
		@item.uploader = current_user
		set_visitor

		if @item.save
			redirect_to @item
		else
			render action: 'new'
		end
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		find_item
		set_visitor

		cannot_edit? @item do
			return
		end

		if @item.update(item_params)
			redirect_to @item
		else
			render action: 'edit'
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		find_item

		cannot_destroy? @item do
			return
		end

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
	def find_item
		@item = Item.friendly.find(params[:id]).decorate
	end

	# ItemParams :: define strong parameters
	def item_params
		params.require(:item).permit(:name, :nature, :editor_level, :publicity_level, :descriptions)
	end

	# Subjects :: find all
	def items
		@subjects = @items = Collectables::ItemsDecorator.decorate Item.order_by_generic
	end

	def set_visitor
		@item.visitor = current_user
	end

end