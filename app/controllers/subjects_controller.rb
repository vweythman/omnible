class SubjectsController < ApplicationController
  def index
  	@characters = Character.not_pen_name.viewable_for(current_user).order('name').decorate
  	@items      = Item.order('generics.name, items.name').includes(:generic).decorate
  	@places     = Place.order('forms.name, places.name').includes(:form).decorate
  end
end
