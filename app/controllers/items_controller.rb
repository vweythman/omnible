class ItemsController < ApplicationController
  def index
  	@items = Item.organized_all
  end

  def show
    @item = Item.find(params[:id])
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
    @item = Item.find(params[:id])
  end

  def update
    @item    = Item.find(params[:id])
    @generic = Generic.where(name: params[:item][:generic_name]).first_or_create

    params[:item][:generic_id] = @generic.id
    if @item.update(item_params)
      redirect_to(:action => 'index')
    else
     render action: 'edit'
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :generic_id)
  end
end
