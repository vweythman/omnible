class SubjectsController < ApplicationController
  def index
  	@characters = Character.all
  	@items      = Item.organized_all
  	@places     = Place.organized_all
  end
end
