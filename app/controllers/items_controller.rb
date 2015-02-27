class ItemsController < ApplicationController
  def index
  	@items = Item.all
  end

  def show
  end

  def new
  	@item = Item.new
  end

  def create
    @generic = Generic.where(name: params[:item][:generic_name]).first_or_create
    @item    = Item.new(item_params)

    @item.generic_id = @generic.id
    if @item.save
      redirect_to(:action => 'index')
    else
      render action: 'new'
    end
  end

  def edit
  end

  private
  def item_params
    params.require(:item).permit(:name, :generic_id)
  end
end
