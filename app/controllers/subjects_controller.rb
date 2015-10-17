class SubjectsController < ApplicationController
  def index
  	@characters = Character.order('name').all
  	@items      = Item.organized_all
  	@places     = Place.order('forms.name, places.name').includes(:form).decorate
  end
end
