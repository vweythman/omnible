class SubjectsController < ApplicationController
	def index
		@characters = Character.not_pen_name.viewable_for(current_user)
		@items      = Item.order('generics.name, items.name').includes(:generic)
		@places     = Place.order('forms.name, places.name').includes(:form)
		@subjects   = SubjectsDecorator.decorate(@characters + @items + @places)
	end
end
